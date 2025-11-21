# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd
## Joystick virtual para controles táctiles.
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
## Si es true, el joystick aparece donde tocas.
@export var modo_dinamico: bool = false

## Zona muerta (0.0 a 1.0).
@export var zona_muerta: float = 0.1

# --- ESTADO ---
var _indice_toque: int = -1
var _pos_base: Vector2
var _pos_palanca_rel: Vector2 = Vector2.ZERO
var _salida: Vector2 = Vector2.ZERO
var _pos_original: Vector2

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_pos_base = size / 2
	_pos_original = position

func _gui_input(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch:
		if evento.pressed:
			if _indice_toque == -1:
				if modo_dinamico or evento.position.distance_to(_pos_base) < radio_base:
					_indice_toque = evento.index
					if modo_dinamico:
						_pos_base = evento.position
						queue_redraw()
					_actualizar_palanca(evento.position)
		elif evento.index == _indice_toque:
			_indice_toque = -1
			_reset_palanca()
			
	elif evento is InputEventScreenDrag:
		if evento.index == _indice_toque:
			_actualizar_palanca(evento.position)

func _draw() -> void:
	if _indice_toque == -1 and modo_dinamico: return
	draw_circle(_pos_base, radio_base, color_base)
	draw_circle(_pos_base + _pos_palanca_rel, radio_palanca, color_palanca)

func _actualizar_palanca(pos_toque: Vector2) -> void:
	var delta = pos_toque - _pos_base
	if delta.length() > radio_base:
		delta = delta.normalized() * radio_base
	
	_pos_palanca_rel = delta
	var salida_cruda = _pos_palanca_rel / radio_base

	if salida_cruda.length() < zona_muerta:
		_salida = Vector2.ZERO
	else:
		_salida = salida_cruda

	queue_redraw()
	_simular_input()

func _reset_palanca() -> void:
	_pos_palanca_rel = Vector2.ZERO
	_salida = Vector2.ZERO
	queue_redraw()
	_liberar_input()

func _simular_input() -> void:
	_actualizar_accion(accion_izquierda, _salida.x < -zona_muerta)
	_actualizar_accion(accion_derecha, _salida.x > zona_muerta)
	_actualizar_accion(accion_arriba, _salida.y < -zona_muerta)
	_actualizar_accion(accion_abajo, _salida.y > zona_muerta)

func _actualizar_accion(accion: String, presionado: bool) -> void:
	if accion == "": return
	if presionado: Input.action_press(accion)
	else: Input.action_release(accion)

func _liberar_input() -> void:
	if accion_izquierda != "": Input.action_release(accion_izquierda)
	if accion_derecha != "": Input.action_release(accion_derecha)
	if accion_arriba != "": Input.action_release(accion_arriba)
	if accion_abajo != "": Input.action_release(accion_abajo)

func obtener_salida() -> Vector2:
	return _salida
