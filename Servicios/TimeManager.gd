# Archivo: addons/no_code_godot_plugin/Servicios/TimeManager.gd
## Manager global de tiempo para efectos de Game Feel (Hit Stop, Slow Motion).
extends Node

var _default_time_scale: float = 1.0
var _tween_time: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

## Congela el juego brevemente (Hit Stop). Útil para impactos fuertes.
## `duracion`: Segundos reales de pausa.
## `escala`: Escala de tiempo durante la pausa (0.0 = congelado total, 0.1 = muy lento).
func hit_stop(duracion: float = 0.1, escala: float = 0.0) -> void:
	Engine.time_scale = escala
	# Usar temporizador del árbol principal que ignora la escala de tiempo
	await get_tree().create_timer(duracion, true, false, true).timeout
	Engine.time_scale = _default_time_scale

## Activa cámara lenta con transición suave.
func slow_motion(escala_objetivo: float = 0.5, duracion_transicion: float = 0.2) -> void:
	if _tween_time: _tween_time.kill()
	_tween_time = create_tween()
	_tween_time.set_process_mode(Tween.TWEEN_PROCESS_IDLE) # Importante: Que corra incluso si time_scale baja
	_tween_time.tween_property(Engine, "time_scale", escala_objetivo, duracion_transicion).set_trans(Tween.TRANS_SINE)

## Restaura la velocidad normal.
func restaurar_tiempo(duracion_transicion: float = 0.2) -> void:
	slow_motion(_default_time_scale, duracion_transicion)
