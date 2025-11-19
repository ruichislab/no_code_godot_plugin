# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteClicker.gd
## Generador de recursos al hacer clic.
##
## **Uso:** Añade este componente para crear juegos clicker/idle.
## Genera recursos cada vez que se hace clic.
##
## **Casos de uso:**
## - Cookie clicker
## - Juegos idle
## - Minijuegos de farmeo
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteClicker
extends Area2D
const _tool_context = "RuichisLab/Nodos"

## Variable global a incrementar.
@export var variable_recurso: String = "dinero"
## Cantidad por clic.
@export var cantidad_base: int = 1
## Sonido al hacer clic.
@export var sonido_click: String = "coin"

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hacer_click()

func hacer_click():
	if VariableManager:
		VariableManager.sumar_variable(variable_recurso, cantidad_base)
		
	if SoundManager:
		SoundManager.play_sfx(sonido_click)
		
	# Animación de "squash"
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	
	if FloatingTextManager:
		FloatingTextManager.mostrar_texto("+" + str(cantidad_base), global_position, Color.YELLOW)
