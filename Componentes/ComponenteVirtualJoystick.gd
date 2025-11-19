# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd
## Joystick virtual para móviles.
##
## **Uso:** Añade este componente para crear controles táctiles.
## Genera inputs de movimiento para dispositivos móviles.
##
## **Casos de uso:**
## - Controles móviles
## - Joystick táctil
## - Controles de tablet
##
## **Requisito:** Debe heredar de Control.
class_name ComponenteVirtualJoystick
extends Control
const _tool_context = "RuichisLab/Nodos"

# Joystick Virtual para móviles.
# Simula acciones de Input Map (ui_left, ui_right, etc.) o devuelve un Vector2.

## Acción del Input Map para mover a la izquierda.
@export var accion_izquierda: String = "ui_left"
## Acción del Input Map para mover a la derecha.
@export var accion_derecha: String = "ui_right"
## Acción del Input Map para mover arriba.
@export var accion_arriba: String = "ui_up"
## Acción del Input Map para mover abajo.
@export var accion_abajo: String = "ui_down"

## Color del fondo del joystick.
@export var color_base: Color = Color(0, 0, 0, 0.5)
## Color de la palanca móvil.
@export var color_palanca: Color = Color(1, 1, 1, 0.8)
## Radio del joystick en píxeles.
@export var radio_base: float = 100.0
@export var radio_palanca: float = 40.0

var touch_index: int = -1
var centro: Vector2
var pos_palanca: Vector2
var output: Vector2 = Vector2.ZERO

func _ready():
	# Asegurar que no bloquee el mouse
	mouse_filter = Control.MOUSE_FILTER_STOP

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if touch_index == -1 and event.position.distance_to(size / 2) < radio_base:
				touch_index = event.index
				_actualizar_palanca(event.position)
		elif event.index == touch_index:
			touch_index = -1
			_reset_palanca()
			
	elif event is InputEventScreenDrag:
		if event.index == touch_index:
			_actualizar_palanca(event.position)

func _draw():
	var centro_rect = size / 2
	draw_circle(centro_rect, radio_base, color_base)
	draw_circle(centro_rect + pos_palanca, radio_palanca, color_palanca)

func _actualizar_palanca(pos_touch: Vector2):
	var centro_rect = size / 2
	var delta = pos_touch - centro_rect
	
	if delta.length() > radio_base:
		delta = delta.normalized() * radio_base
	
	pos_palanca = delta
	output = pos_palanca / radio_base
	queue_redraw()
	_simular_input()

func _reset_palanca():
	pos_palanca = Vector2.ZERO
	output = Vector2.ZERO
	queue_redraw()
	_liberar_input()

func _simular_input():
	# Simular pulsaciones de teclas para que funcione con CharacterBody2D existente
	if output.x < -0.5: Input.action_press(accion_izquierda)
	else: Input.action_release(accion_izquierda)
	
	if output.x > 0.5: Input.action_press(accion_derecha)
	else: Input.action_release(accion_derecha)
	
	if output.y < -0.5: Input.action_press(accion_arriba)
	else: Input.action_release(accion_arriba)
	
	if output.y > 0.5: Input.action_press(accion_abajo)
	else: Input.action_release(accion_abajo)

func _liberar_input():
	Input.action_release(accion_izquierda)
	Input.action_release(accion_derecha)
	Input.action_release(accion_arriba)
	Input.action_release(accion_abajo)

func get_output() -> Vector2:
	return output