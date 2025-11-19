# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTimer.gd
## Temporizador visual con cuenta regresiva.
##
## **Uso:** Añade este nodo para crear desafíos con límite de tiempo.
## Ejecuta acciones cuando el tiempo se agota.
##
## **Casos de uso:**
## - Niveles contrarreloj
## - Bombas de tiempo
## - Eventos limitados
## - Speedrun challenges
##
## **Nota:** Muestra el tiempo restante en pantalla automáticamente.
@icon("res://icon.svg")
class_name ComponenteTimer
extends Node
const _tool_context = "RuichisLab/Nodos"

signal tiempo_agotado()

@export var tiempo: float = 1.0
@export var auto_start: bool = true
@export var repetir: bool = false
@export var aleatoriedad: float = 0.0

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = !repetir
	timer.timeout.connect(_on_timeout)
	
	if auto_start:
		iniciar()

func iniciar():
	var t = tiempo + randf_range(-aleatoriedad, aleatoriedad)
	timer.start(max(0.05, t))

func detener():
	timer.stop()

func _on_timeout():
	emit_signal("tiempo_agotado")
	if repetir and aleatoriedad > 0:
		# Reiniciar con nuevo tiempo aleatorio si es necesario
		iniciar()
