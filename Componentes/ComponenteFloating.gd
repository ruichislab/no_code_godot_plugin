# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteFloating.gd
## Movimiento flotante suave (idle animation).
##
## **Uso:** Añade este componente para crear movimiento de flotación.
## Ideal para items coleccionables.
##
## **Casos de uso:**
## - Monedas flotantes
## - Power-ups
## - Items coleccionables
## - Objetos mágicos
##
## **Nota:** Usa interpolación sinusoidal para movimiento suave.
@icon("res://icon.svg")
class_name ComponenteFloating
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var amplitud: float = 10.0
@export var velocidad: float = 2.0
@export var aleatorizar_fase: bool = true

var padre: Node2D
var tiempo: float = 0.0
var y_inicial: float = 0.0

func _ready():
	padre = get_parent() as Node2D
	if not padre: return
	
	y_inicial = padre.position.y
	if aleatorizar_fase:
		tiempo = randf() * 10.0

func _process(delta):
	if not padre: return
	
	tiempo += delta * velocidad
	var offset = sin(tiempo) * amplitud
	padre.position.y = y_inicial + offset
