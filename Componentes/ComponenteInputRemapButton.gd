# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInputRemapButton.gd
## Botón para remapear controles.
##
## **Uso:** Añade este componente para permitir personalizar controles.
## Captura el input del jugador y lo asigna a una acción.
##
## **Casos de uso:**
## - Menú de controles
## - Personalización de teclas
## - Soporte para gamepad
##
## **Requisito:** Debe heredar de Button.
@icon("res://icon.svg")
class_name ComponenteInputRemapButton
extends Button
const _tool_context = "RuichisLab/Nodos"

@export var accion: String = "ui_accept"
@export var texto_esperando: String = "Presiona una tecla..."

var esperando_input: bool = false

func _ready():
	actualizar_texto()
	pressed.connect(_on_pressed)

func actualizar_texto():
	var eventos = InputMap.action_get_events(accion)
	var tecla = "Ninguna"
	if eventos.size() > 0:
		var evento = eventos[0]
		if evento is InputEventKey:
			if typeof(OS) != TYPE_NIL and OS.has_method("get_keycode_string"):
				tecla = OS.call("get_keycode_string", evento.physical_keycode)
			else:
				tecla = str(evento.physical_keycode)
		elif evento is InputEventMouseButton:
			tecla = "Mouse " + str(evento.button_index)
		elif evento is InputEventJoypadButton:
			tecla = "JoyBtn " + str(evento.button_index)
			
	text = "%s: %s" % [accion.capitalize(), tecla]

func _on_pressed():
	esperando_input = true
	text = texto_esperando
	release_focus() # Perder foco para no activar con Enter/Espacio inmediatamente

func _input(event):
	if not esperando_input: return
	
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		if event.is_pressed():
			# Reasignar
			InputMap.action_erase_events(accion)
			InputMap.action_add_event(accion, event)
			
			esperando_input = false
			actualizar_texto()
			accept_event()
			
			# Guardar configuración (Opcional, requeriría un SettingsManager persistente)
			# SettingsManager.guardar_inputs()
