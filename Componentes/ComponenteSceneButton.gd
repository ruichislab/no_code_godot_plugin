# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSceneButton.gd
## Botón especializado en cambios de escena (niveles o menús).
##
## **Uso:** Simplemente asignar la escena destino en el inspector.
## Maneja automáticamente el sonido de click y la llamada al GameManager.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_SceneButton
extends Button

# --- CONFIGURACIÓN ---

## Ruta a la escena (.tscn) que se cargará al pulsar.
@export_file("*.tscn") var escena_destino: String

## Si es true, usa el GameManager para transición (si existe). Si false, cambio directo.
@export var usar_transicion: bool = true

## Sonido opcional al pulsar (ID del AudioManager).
@export var sonido_click: String = "ui_click"

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if escena_destino == "":
		push_error("RL_SceneButton: No se ha asignado escena de destino.")
		return
		
	# Sonido
	if sonido_click != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_click)
	
	# Cambio de escena
	if usar_transicion and Engine.has_singleton("GameManager"):
		Engine.get_singleton("GameManager").cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if escena_destino == "":
		warnings.append("Debes seleccionar una escena de destino (.tscn).")
	return warnings
