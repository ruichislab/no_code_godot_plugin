# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSceneButton.gd
## Botón que cambia de escena.
##
## **Uso:** Añade este componente a botones para cambiar de nivel/menú.
## Maneja la transición automáticamente.
##
## **Casos de uso:**
## - Botón "Jugar"
## - Botón "Siguiente Nivel"
## - Botón "Volver al Menú"
## - Botones de selección de nivel
##
## **Requisito:** Debe heredar de Button.
@icon("res://icon.svg")
class_name ComponenteSceneButton
extends Button
const _tool_context = "RuichisLab/Nodos"

@export_file("*.tscn") var escena_destino: String
@export var usar_transicion: bool = true

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	if escena_destino == "":
		push_error("NC_SceneButton: No hay escena asignada.")
		return
		
	if SoundManager:
		SoundManager.play_sfx("ui_click") # Sonido genérico si existe
	
	if usar_transicion and SceneManager:
		SceneManager.cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)
