# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInputRemapButton.gd
## Botón para reasignar teclas/controles.
##
## **Uso:** Al pulsar, espera el siguiente input y lo asigna a la acción.
## **Requisito:** Button.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_InputRemapButton
extends Button

# --- CONFIGURACIÓN ---
@export var accion: String = "ui_accept"
@export var texto_espera: String = "Presiona tecla..."

# --- ESTADO ---
var _esperando_input: bool = false

func _ready() -> void:
	pressed.connect(_al_presionar)
	_actualizar_etiqueta()

func _actualizar_etiqueta() -> void:
	var eventos = InputMap.action_get_events(accion)
	var tecla = "Ninguna"

	if eventos.size() > 0:
		var evento = eventos[0]
		if evento is InputEventKey:
			tecla = OS.get_keycode_string(evento.physical_keycode)
		elif evento is InputEventMouseButton:
			tecla = "Mouse %d" % evento.button_index
		elif evento is InputEventJoypadButton:
			tecla = "JoyBtn %d" % evento.button_index
			
	text = "%s: %s" % [accion.capitalize(), tecla]

func _al_presionar() -> void:
	_esperando_input = true
	text = texto_espera
	release_focus()

func _input(evento: InputEvent) -> void:
	if not _esperando_input: return
	
	# Filtrar eventos válidos
	if evento is InputEventKey or evento is InputEventMouseButton or evento is InputEventJoypadButton:
		if evento.is_pressed():
			# Limpiar y asignar
			InputMap.action_erase_events(accion)
			InputMap.action_add_event(accion, evento)
			
			_esperando_input = false
			_actualizar_etiqueta()
			accept_event()
			
			# Persistir
			if Engine.has_singleton("SettingsManager"):
				Engine.get_singleton("SettingsManager").call("guardar_ajustes")

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not InputMap.has_action(accion):
		warnings.append("La acción '%s' no existe en el InputMap." % accion)
	return warnings
