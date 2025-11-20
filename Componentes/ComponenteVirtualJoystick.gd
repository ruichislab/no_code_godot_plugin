# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd
## Joystick virtual en pantalla para controles táctiles (Móvil).
##
## **Uso:** Emula acciones del Input Map (izquierda/derecha/arriba/abajo) o devuelve un vector.
## **Requisito:** Control (CanvasLayer o UI overlay).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_VirtualJoystick
extends Control

# --- CONFIGURACIÓN ---

@export_group("Input Map")
@export var accion_izquierda: String = "ui_left"
@export var accion_derecha: String = "ui_right"
@export var accion_arriba: String = "ui_up"
@export var accion_abajo: String = "ui_down"

@export_group("Visuales")
@export var color_base: Color = Color(0, 0, 0, 0.5)
@export var color_palanca: Color = Color(1, 1, 1, 0.8)
@export var radio_base: float = 100.0
@export var radio_palanca: float = 40.0

@export_group("Comportamiento")
## Si es true, el joystick aparece donde tocas (Dynamic Joystick).
@export var modo_dinamico: bool = false

## Zona muerta antes de registrar movimiento (0.0 a 1.0).
@export var zona_muerta: float = 0.1

# --- ESTADO ---
var _touch_index: int = -1
var _pos_base: Vector2
var _pos_palanca_rel: Vector2 = Vector2.ZERO
var _output: Vector2 = Vector2.ZERO
var _pos_original: Vector2

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_pos_base = size / 2
	_pos_original = position # Para modo dinámico si se implementa reset

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Iniciar toque si no hay otro activo
			if _touch_index == -1:
				if modo_dinamico or event.position.distance_to(_pos_base) < radio_base:
					_touch_index = event.index
					if modo_dinamico:
						_pos_base = event.position
						queue_redraw()
					_actualizar_palanca(event.position)
		elif event.index == _touch_index:
			# Soltar toque
			_touch_index = -1
			_reset_palanca()
			
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			_actualizar_palanca(event.position)

func _draw() -> void:
	if _touch_index == -1 and modo_dinamico: return # Ocultar si es dinámico y no se toca

	# Dibujar Base
	draw_circle(_pos_base, radio_base, color_base)

	# Dibujar Palanca
	draw_circle(_pos_base + _pos_palanca_rel, radio_palanca, color_palanca)

func _actualizar_palanca(pos_touch: Vector2) -> void:
	var delta = pos_touch - _pos_base
	
	# Limitar al radio
	if delta.length() > radio_base:
		delta = delta.normalized() * radio_base
	
	_pos_palanca_rel = delta

	# Calcular output normalizado
	var raw_output = _pos_palanca_rel / radio_base

	# Zona muerta
	if raw_output.length() < zona_muerta:
		_output = Vector2.ZERO
	else:
		_output = raw_output

	queue_redraw()
	_simular_input()

func _reset_palanca() -> void:
	_pos_palanca_rel = Vector2.ZERO
	_output = Vector2.ZERO
	if modo_dinamico:
		# Resetear posición base si se desea, o dejarla oculta
		pass

	queue_redraw()
	_liberar_input()

func _simular_input() -> void:
	# Emular acciones físicas
	_actualizar_accion(accion_izquierda, _output.x < -zona_muerta)
	_actualizar_accion(accion_derecha, _output.x > zona_muerta)
	_actualizar_accion(accion_arriba, _output.y < -zona_muerta)
	_actualizar_accion(accion_abajo, _output.y > zona_muerta)

func _actualizar_accion(accion: String, presionado: bool) -> void:
	if accion == "": return
	
	if presionado:
		Input.action_press(accion)
	else:
		Input.action_release(accion)

func _liberar_input() -> void:
	if accion_izquierda != "": Input.action_release(accion_izquierda)
	if accion_derecha != "": Input.action_release(accion_derecha)
	if accion_arriba != "": Input.action_release(accion_arriba)
	if accion_abajo != "": Input.action_release(accion_abajo)

## Obtener el vector de movimiento (-1 a 1).
func get_output() -> Vector2:
	return _output
