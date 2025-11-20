# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCard.gd
## Carta interactiva con soporte Drag & Drop nativo de Godot.
##
## **Uso:** Representa una carta visual. Se puede arrastrar a un `RL_CardSlot` o `RL_PlayArea`.
## **Requisito:** Debe ser hijo de un Control (idealmente `RL_Hand`).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Card
extends Control

# --- SEÑALES ---
signal carta_jugada(carta: RL_Card)
signal carta_seleccionada(carta: RL_Card)
signal drag_iniciado(carta: RL_Card)
signal drag_terminado(carta: RL_Card)

# --- CONFIGURACIÓN ---
@export_group("Datos")
@export var data_carta: ResourceCardData:
	set(val):
		data_carta = val
		if is_inside_tree(): _actualizar_visual()

@export_group("Visuales")
@export var textura_frente: Texture2D
@export var textura_dorso: Texture2D
@export var mostrar_dorso: bool = false:
	set(val):
		mostrar_dorso = val
		_actualizar_visual()

# --- NODOS INTERNOS (Se crean o buscan automáticamente) ---
var _texture_rect: TextureRect
var _label_coste: Label
var _label_nombre: Label
var _label_desc: Label

var _origen_padre: Node
var _posicion_original: Vector2

func _ready() -> void:
	custom_minimum_size = Vector2(150, 220) # Tamaño por defecto
	
	# Configurar TextureRect
	_texture_rect = get_node_or_null("Fondo")
	if not _texture_rect:
		_texture_rect = TextureRect.new()
		_texture_rect.name = "Fondo"
		_texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		_texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(_texture_rect)
		move_child(_texture_rect, 0)

	# Configurar Labels (Opcional, si el usuario quiere texto dinámico)
	# Se pueden añadir manualmente en la escena y el script los usará si tienen nombres específicos
	_label_coste = get_node_or_null("Coste")
	_label_nombre = get_node_or_null("Nombre")
	_label_desc = get_node_or_null("Descripcion")
	
	_actualizar_visual()

func configurar(data: ResourceCardData) -> void:
	data_carta = data
	_actualizar_visual()

func _actualizar_visual() -> void:
	if not is_inside_tree(): return

	var tex = textura_frente
	if mostrar_dorso:
		tex = textura_dorso
	elif data_carta and data_carta.icono:
		tex = data_carta.icono

	if _texture_rect:
		_texture_rect.texture = tex

	if data_carta:
		if _label_coste: _label_coste.text = str(data_carta.coste)
		if _label_nombre: _label_nombre.text = data_carta.nombre
		if _label_desc: _label_desc.text = data_carta.descripcion

# --- DRAG & DROP NATIVO ---

func _get_drag_data(at_position: Vector2) -> Variant:
	if mostrar_dorso: return null # No arrastrar si está boca abajo

	_origen_padre = get_parent()
	_posicion_original = position
	
	# Crear Preview (Fantasma)
	var preview = Control.new()
	var tex = TextureRect.new()
	tex.texture = _texture_rect.texture
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.size = size
	tex.modulate.a = 0.8
	# Centrar el preview en el mouse
	tex.position = -size / 2
	
	preview.add_child(tex)
	set_drag_preview(preview)
	
	emit_signal("drag_iniciado", self)

	# Devolvemos un diccionario con info útil
	return {
		"tipo": "RL_CARD",
		"referencia": self,
		"data": data_carta
	}

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		emit_signal("drag_terminado", self)
		if not is_drag_successful():
			_regresar_a_mano()

func _regresar_a_mano() -> void:
	# Animación simple de retorno si no se jugó
	var tween = create_tween()
	# Nota: Si usas un Container (HBox/Grid), la posición es gestionada por el padre.
	# Este tween es visual solo si el padre no fuerza la posición inmediatamente.
	pass

func regresar_al_deck() -> void:
	queue_free() # O lógica de devolver al mazo

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("carta_seleccionada", self)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not data_carta:
		warnings.append("Se recomienda asignar un ResourceCardData.")
	return warnings
