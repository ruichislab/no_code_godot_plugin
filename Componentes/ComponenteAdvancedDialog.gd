# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteAdvancedDialog.gd
## Sistema de diálogos avanzado con ramificaciones.
##
## **Uso:** Sistema completo de diálogos con soporte para:
## - Múltiples líneas de texto
## - Retratos de personajes
## - Opciones de respuesta
## - Ramificaciones condicionales
## - Efectos de sonido
##
## **Casos de uso:**
## - Conversaciones con NPCs
## - Sistemas de quest
## - Visual novels
## - Cinemáticas narrativas
##
## **Requisito:** Debe ser hijo de un Area2D. Usa RecursoDialogo para definir conversaciones.
@icon("res://icon.svg")
class_name ComponenteAdvancedDialog
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var dialogo_inicial: RecursoDialogo
@export var usar_ui_propia: bool = true

var ui_instancia: CanvasLayer

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Conectarse al DialogueManager para saber cuándo mostrar cosas
	if DialogueManager:
		DialogueManager.dialogo_iniciado.connect(_on_dialogo_iniciado)
		DialogueManager.linea_mostrada.connect(_on_linea_mostrada)
		DialogueManager.opciones_mostradas.connect(_on_opciones_mostradas)
		DialogueManager.dialogo_terminado.connect(_on_dialogo_terminado)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		iniciar()

func iniciar():
	if not dialogo_inicial: return
	
	if DialogueManager:
		DialogueManager.iniciar_dialogo(dialogo_inicial)
	else:
		push_error("DialogueManager no está cargado en Autoloads.")

# --- Lógica de UI (Si no hay una UI global) ---

func _crear_ui_basica():
	if ui_instancia: return
	
	# Crear CanvasLayer para que esté sobre todo
	ui_instancia = CanvasLayer.new()
	add_child(ui_instancia)
	
	# Panel de fondo
	var panel = PanelContainer.new()
	panel.name = "PanelDialogo"
	panel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	panel.offset_top = -200
	panel.offset_bottom = -20
	panel.offset_left = 50
	panel.offset_right = -50
	ui_instancia.add_child(panel)
	
	# Layout vertical
	var vbox = VBoxContainer.new()
	panel.add_child(vbox)
	
	# Nombre
	var label_nombre = Label.new()
	label_nombre.name = "Nombre"
	label_nombre.add_theme_font_size_override("font_size", 24)
	label_nombre.add_theme_color_override("font_color", Color.YELLOW)
	vbox.add_child(label_nombre)
	
	# Texto
	var label_texto = RichTextLabel.new()
	label_texto.name = "Texto"
	label_texto.fit_content = true
	label_texto.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(label_texto)
	
	# Retrato (TextureRect)
	var retrato = TextureRect.new()
	retrato.name = "Retrato"
	retrato.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	retrato.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	retrato.custom_minimum_size = Vector2(128, 128)
	retrato.position = Vector2(50, -150) # Posición manual "flotante"
	# Nota: En una UI real esto se maquetaría mejor
	panel.add_child(retrato)

func _on_dialogo_iniciado(recurso):
	if usar_ui_propia:
		_crear_ui_basica()

func _on_linea_mostrada(texto, nombre):
	if not ui_instancia: return
	
	var panel = ui_instancia.get_node("PanelDialogo")
	var lbl_nombre = panel.get_node("VBoxContainer/Nombre")
	var lbl_texto = panel.get_node("VBoxContainer/Texto")
	var tex_retrato = panel.get_node("Retrato")
	
	lbl_nombre.text = nombre
	lbl_texto.text = texto
	
	# Efecto de escritura simple (Tween)
	lbl_texto.visible_ratio = 0.0
	var tween = create_tween()
	tween.tween_property(lbl_texto, "visible_ratio", 1.0, len(texto) * 0.03)
	
	# Actualizar retrato si existe en el recurso actual
	if DialogueManager.dialogo_actual and DialogueManager.dialogo_actual.retrato:
		tex_retrato.texture = DialogueManager.dialogo_actual.retrato
		tex_retrato.visible = true
	else:
		tex_retrato.visible = false

func _on_opciones_mostradas(opciones):
	# TODO: Implementar botones de opciones en la UI propia
	pass

func _on_dialogo_terminado():
	if ui_instancia:
		ui_instancia.queue_free()
		ui_instancia = null

func _input(event):
	# Avanzar diálogo con clic o espacio
	if ui_instancia and event.is_action_pressed("ui_accept"):
		if DialogueManager:
			DialogueManager.mostrar_siguiente_linea()
