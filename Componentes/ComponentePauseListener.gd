# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePauseListener.gd
## Gestiona la visualización de menús de pausa y responde a eventos de pausa.
##
## **Uso:** Asigna un Control (UI de pausa) y este componente lo mostrará/ocultará automáticamente.
## **Requisito:** Conecta con las señales `juego_pausado` y `juego_reanudado` del GameManager.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_PauseListener
extends Node

# --- CONFIGURACIÓN ---

## Nodo UI (Control) que contiene el menú de pausa.
@export var pantalla_pausa: Control

## Sonido al pausar.
@export var sonido_pausa: String = "pause_on"

## Sonido al reanudar.
@export var sonido_reanudar: String = "pause_off"

## Tecla (Input Action) que alterna la pausa (ej: "ui_cancel", "pause").
@export var accion_toggle: String = "ui_cancel"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Esencial para funcionar durante la pausa
	
	if Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		if gm.has_signal("juego_pausado"):
			gm.juego_pausado.connect(_on_pausado)
		if gm.has_signal("juego_reanudado"):
			gm.juego_reanudado.connect(_on_reanudado)
		
	if pantalla_pausa:
		pantalla_pausa.visible = get_tree().paused

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(accion_toggle):
		alternar_pausa()

func alternar_pausa() -> void:
	if Engine.has_singleton("GameManager"):
		Engine.get_singleton("GameManager").toggle_pausa()
	else:
		# Fallback simple si no hay GM
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			_on_pausado()
		else:
			_on_reanudado()

func _on_pausado() -> void:
	if pantalla_pausa: pantalla_pausa.visible = true
	if sonido_pausa != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_pausa)

func _on_reanudado() -> void:
	if pantalla_pausa: pantalla_pausa.visible = false
	if sonido_reanudar != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_reanudar)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not pantalla_pausa:
		warnings.append("Asigna un nodo Control para mostrar cuando el juego se pause.")
	return warnings
