# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteQuitButton.gd
## Botón para salir del juego.
##
## **Uso:** Añade este componente a botones de "Salir" o "Cerrar".
## Cierra la aplicación de forma segura.
##
## **Casos de uso:**
## - Botón "Salir" en menú principal
## - Botón "Cerrar" en opciones
##
## **Requisito:** Debe heredar de Button.
@icon("res://icon.svg")
class_name ComponenteQuitButton
extends Button
const _tool_context = "RuichisLab/Nodos"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx("ui_click")
		pass
		
	print("Saliendo del juego...")
	get_tree().quit()

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null
