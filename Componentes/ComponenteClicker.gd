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
	var vm = _get_variable_manager()
	if vm:
		vm.sumar_variable(variable_recurso, cantidad_base)
		
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx(sonido_click)
		pass
		
	# Animación de "squash"
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	
	var ftm = _get_floating_text_manager()
	if ftm:
		ftm.mostrar_texto("+" + str(cantidad_base), global_position, Color.YELLOW)

func _get_variable_manager() -> Node:
	if Engine.has_singleton("VariableManager"): return Engine.get_singleton("VariableManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("VariableManager")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null
