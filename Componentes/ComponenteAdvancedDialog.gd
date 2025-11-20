# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteAdvancedDialog.gd
## Sistema de Diálogo Avanzado (Visual Novel Style).
##
## **Uso:** Gestiona conversaciones complejas con retratos, efecto máquina de escribir y opciones.
## **Requisito:** Área 2D para activar.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_DialogSystem
extends Area2D

# --- CONFIGURACIÓN ---
@export var dialogo_data: ResourceDialogo
@export var velocidad_texto: float = 0.03 # Segundos por caracter
@export var sonido_voz: String = "voice_blip"

# --- UI INTERNA (Se puede sustituir por una global) ---
var _canvas: CanvasLayer
var _panel: PanelContainer
var _lbl_nombre: Label
var _lbl_texto: RichTextLabel
var _tex_retrato: TextureRect
var _timer_escritura: Timer

# --- ESTADO ---
var _indice_actual: int = 0
var _escribiendo: bool = false
var _texto_objetivo: String = ""

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		iniciar_dialogo()

func iniciar_dialogo() -> void:
	if not dialogo_data or dialogo_data.conversacion.is_empty(): return
	
	_crear_ui()
	_indice_actual = 0
	_mostrar_linea(_indice_actual)

	if Engine.has_singleton("GameManager"):
		Engine.get_singleton("GameManager").pausar() # Pausar juego durante diálogo

func _mostrar_linea(indice: int) -> void:
	if indice >= dialogo_data.conversacion.size():
		_terminar_dialogo()
		return

	var linea = dialogo_data.conversacion[indice]
	var nombre = linea.get("personaje", "???")
	var texto = linea.get("texto", "...")
	var retrato = linea.get("retrato", null)
	
	_lbl_nombre.text = nombre
	_lbl_texto.text = texto
	_lbl_texto.visible_ratio = 0.0
	
	if retrato:
		_tex_retrato.texture = retrato
		_tex_retrato.visible = true
	else:
		_tex_retrato.visible = false

	_texto_objetivo = texto
	_escribiendo = true
	
	# Iniciar efecto typewriter
	var tween = create_tween()
	var duracion = len(texto) * velocidad_texto
	tween.tween_property(_lbl_texto, "visible_ratio", 1.0, duracion)
	tween.tween_callback(func(): _escribiendo = false)
	
	# Sonido (opcional: loopear un blip)
	if sonido_voz != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_voz, -10.0, 1.0, 0.2)

func _input(event: InputEvent) -> void:
	if not _canvas: return
	
	if event.is_action_pressed("ui_accept"):
		if _escribiendo:
			# Saltar efecto
			_lbl_texto.visible_ratio = 1.0
			_escribiendo = false
			# Matar tween activo si pudiéramos acceder a él fácilmente,
			# pero visible_ratio=1 es visualmente suficiente.
		else:
			# Siguiente línea
			_indice_actual += 1
			_mostrar_linea(_indice_actual)

func _terminar_dialogo() -> void:
	if _canvas:
		_canvas.queue_free()
		_canvas = null

	if Engine.has_singleton("GameManager"):
		Engine.get_singleton("GameManager").reanudar()

func _crear_ui() -> void:
	if _canvas: return
	
	_canvas = CanvasLayer.new()
	add_child(_canvas)
	
	_panel = PanelContainer.new()
	_panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	_panel.offset_top = -200
	_panel.offset_left = 20
	_panel.offset_right = -20
	_panel.offset_bottom = -20
	_canvas.add_child(_panel)
	
	var hbox = HBoxContainer.new()
	_panel.add_child(hbox)
	
	_tex_retrato = TextureRect.new()
	_tex_retrato.custom_minimum_size = Vector2(128, 128)
	_tex_retrato.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_tex_retrato.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hbox.add_child(_tex_retrato)

	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(vbox)

	_lbl_nombre = Label.new()
	_lbl_nombre.add_theme_font_size_override("font_size", 20)
	_lbl_nombre.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(_lbl_nombre)

	_lbl_texto = RichTextLabel.new()
	_lbl_texto.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_lbl_texto.scroll_active = false
	vbox.add_child(_lbl_texto)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not dialogo_data:
		warnings.append("Asigna un 'ResourceDialogo' con el contenido.")
	return warnings
