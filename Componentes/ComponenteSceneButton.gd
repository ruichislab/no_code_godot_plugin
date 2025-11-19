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
		
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx("ui_click") # Sonido genérico si existe
		pass
	
	var scm = _get_scene_manager()
	if usar_transicion and scm:
		scm.cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null

func _get_scene_manager() -> Node:
	if Engine.has_singleton("SceneManager"): return Engine.get_singleton("SceneManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SceneManager")
	return null
