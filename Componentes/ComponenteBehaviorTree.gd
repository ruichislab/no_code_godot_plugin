# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteBehaviorTree.gd
## Árbol de comportamiento para IA avanzada.
##
## **Uso:** Sistema de IA basado en árboles de decisión.
## Más flexible que máquinas de estados para comportamientos complejos.
##
## **Casos de uso:**
## - IA de estrategia
## - Enemigos tácticos
## - Compañeros aliados
## - NPCs con múltiples prioridades
##
## **Nota:** Requiere definir nodos de comportamiento como Resources.
@icon("res://icon.svg")
class_name ComponenteBehaviorTree
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var arbol: BTNode
@export var activo: bool = true
@export var intervalo_tick: float = 0.1 # No ejecutar cada frame para rendimiento

var blackboard: Blackboard
var timer: Timer

func _ready():
	blackboard = Blackboard.new()
	
	# Configurar timer
	timer = Timer.new()
	timer.wait_time = intervalo_tick
	timer.autostart = true
	timer.timeout.connect(_on_tick)
	add_child(timer)

func _on_tick():
	if not activo or not arbol: return
	
	arbol.tick(get_parent(), blackboard)

func get_blackboard() -> Blackboard:
	return blackboard
