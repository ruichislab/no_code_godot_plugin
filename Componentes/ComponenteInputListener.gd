# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInputListener.gd
## Detecta entradas del usuario (Input Map) y emite señales.
##
## **Uso:** Ideal para disparar eventos, abrir menús o activar habilidades sin programar.
## Requiere que la acción esté definida en Proyecto > Configuración del Proyecto > Mapa de Entradas.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_InputListener
extends Node

# --- CONFIGURACIÓN ---

## Nombre de la acción definida en el Input Map (ej: "ui_accept", "saltar").
@export var accion: String = "ui_accept"

## Si es true, procesa la entrada. Si es false, ignora todo.
@export var activo: bool = true

## Si es true, consume el evento para que no se propague a otros nodos (usando _unhandled_input).
@export var consumir_evento: bool = false

# --- SEÑALES ---
signal presionado
signal soltado
signal mantenido(delta: float)

func _process(delta: float) -> void:
	if not activo: return
	
	if Input.is_action_pressed(accion):
		emit_signal("mantenido", delta)

func _unhandled_input(event: InputEvent) -> void:
	if not activo: return

	if event.is_action(accion):
		if event.is_pressed() and not event.is_echo():
			emit_signal("presionado")
			if consumir_evento: get_viewport().set_input_as_handled()

		elif event.is_released():
			emit_signal("soltado")
			if consumir_evento: get_viewport().set_input_as_handled()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not InputMap.has_action(accion):
		warnings.append("La acción '%s' no existe en el Input Map del proyecto." % accion)
	return warnings
