# Archivo: addons/genesis_framework/Servicios/TimeManager.gd
extends Node

# Configurar como Autoload: "TimeManager"
# Gestiona la escala de tiempo global, pausas y efectos de "Hit Stop".

var escala_original: float = 1.0
var tween_tiempo: Tween

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# Efecto "Matrix" o Cámara Lenta
func set_time_scale(escala: float, duracion_transicion: float = 0.0):
	if tween_tiempo and tween_tiempo.is_valid():
		tween_tiempo.kill()
		
	if duracion_transicion > 0:
		tween_tiempo = create_tween()
		tween_tiempo.tween_property(Engine, "time_scale", escala, duracion_transicion)
	else:
		Engine.time_scale = escala

# Efecto de "Impacto" (Congelar el juego unos milisegundos al golpear)
func hit_stop(duracion_segundos: float, escala_durante_stop: float = 0.05):
	if tween_tiempo and tween_tiempo.is_valid():
		tween_tiempo.kill()
		
	var escala_anterior = Engine.time_scale
	Engine.time_scale = escala_durante_stop
	
	# Usar un timer de árbol real para restaurar, ignorando time_scale
	await get_tree().create_timer(duracion_segundos, true, false, true).timeout
	
	Engine.time_scale = escala_anterior

func pausar_juego(pausa: bool):
	get_tree().paused = pausa
