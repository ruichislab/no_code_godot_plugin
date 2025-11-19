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
	if SoundManager:
		SoundManager.play_sfx("ui_click")
		
	print("Saliendo del juego...")
	get_tree().quit()
