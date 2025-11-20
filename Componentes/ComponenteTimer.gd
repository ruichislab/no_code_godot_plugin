# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTimer.gd
## Temporizador simple que emite una señal al terminar.
##
## **Uso:** Desafíos de tiempo, spawners personalizados, eventos cíclicos.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Timer
extends Node

# --- SEÑALES ---
signal tiempo_agotado

# --- CONFIGURACIÓN ---

## Tiempo base en segundos.
@export var tiempo: float = 1.0

## Si es true, comienza automáticamente al cargar la escena.
@export var auto_start: bool = true

## Si es true, el temporizador se reinicia al terminar (cíclico).
@export var repetir: bool = false

## Variación aleatoria (+/- segundos) aplicada a cada ciclo.
@export var aleatoriedad: float = 0.0

var timer_interno: Timer

func _ready() -> void:
	timer_interno = Timer.new()
	add_child(timer_interno)
	timer_interno.one_shot = !repetir
	timer_interno.timeout.connect(_on_timeout)
	
	if auto_start:
		iniciar()

func iniciar() -> void:
	var t = tiempo + randf_range(-aleatoriedad, aleatoriedad)
	timer_interno.start(max(0.05, t))

func detener() -> void:
	timer_interno.stop()

func pausar() -> void:
	timer_interno.paused = true

func reanudar() -> void:
	timer_interno.paused = false

func _on_timeout() -> void:
	emit_signal("tiempo_agotado")
	if repetir and aleatoriedad > 0:
		# Si hay aleatoriedad en repetición, hay que reiniciar manualmente para recalcular
		# Nota: Timer estándar reinicia con wait_time original.
		iniciar()

func obtener_tiempo_restante() -> float:
	return timer_interno.time_left
