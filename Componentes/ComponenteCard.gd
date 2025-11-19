# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCard.gd
## Carta interactiva para juegos de cartas.
##
## **Uso:** Añade este componente para crear cartas jugables.
## Incluye animaciones de hover, drag y drop.
##
## **Casos de uso:**
## - Juegos de cartas coleccionables
## - Deck builders
## - Solitario
## - Poker
##
## **Requisito:** Debe heredar de Control.
class_name ComponenteCard
extends Control
const _tool_context = "RuichisLab/Nodos"

signal carta_jugada(carta)
signal carta_seleccionada(carta)

@export_group("Datos")
@export var data_carta: ResourceCardData
# Propiedades legacy para compatibilidad, se sobrescriben si hay data_carta
@export var id_carta: String = "carta_base"
@export var coste: int = 1
@export var valor: int = 5

@export_group("Visuales")
@export var textura_frente: Texture2D
@export var textura_dorso: Texture2D
@export var es_visible: bool = true:
	set(val):
		es_visible = val
		actualizar_visual()

var texture_rect: TextureRect
var dragging: bool = false
var drag_offset: Vector2
var posicion_original: Vector2

func _ready():
	if get_child_count() == 0:
		texture_rect = TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(texture_rect)
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE 
	else:
		for child in get_children():
			if child is TextureRect:
				texture_rect = child
				break
	
	if data_carta:
		configurar(data_carta)
	else:
		actualizar_visual()
	
	# Usaremos el sistema nativo de Godot _get_drag_data si es posible,
	# pero mantenemos gui_input para clicks simples o lógica custom si se prefiere.
	# Para drag nativo, Control debe tener mouse_filter en STOP o PASS.

func configurar(data: ResourceCardData):
	data_carta = data
	id_carta = data.id
	coste = data.coste
	if data.icono:
		textura_frente = data.icono
	actualizar_visual()

func actualizar_visual():
	if not texture_rect: return
	if es_visible:
		texture_rect.texture = textura_frente
	else:
		texture_rect.texture = textura_dorso

func get_card_data() -> ResourceCardData:
	return data_carta

# --- SISTEMA NATIVO DE DRAG & DROP ---
func _get_drag_data(at_position):
	# Crear preview visual
	var preview = TextureRect.new()
	preview.texture = textura_frente if es_visible else textura_dorso
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = size
	preview.modulate.a = 0.8
	
	var c = Control.new()
	c.add_child(preview)
	preview.position = -at_position # Centrar bajo el mouse relativo al click
	
	set_drag_preview(c)
	
	return self # Devolvemos la referencia a la carta misma

# --- SISTEMA LEGACY (Opcional, si se prefiere movimiento libre sin slots) ---
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				emit_signal("carta_seleccionada", self)