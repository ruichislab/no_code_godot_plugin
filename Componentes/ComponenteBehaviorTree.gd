# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteBehaviorTree.gd
## Ejecutor de Árboles de Comportamiento (Behavior Tree).
##
## **Uso:** Asigna un recurso `RL_BTNode` (usualmente un Selector o Secuencia raíz).
## **Características:** Ejecuta la lógica de IA en intervalos regulares.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_BehaviorTree
extends Node

# --- CONFIGURACIÓN ---

## Nodo raíz del árbol (Recurso).
@export var arbol: RL_BTNode

## Si es true, el árbol se ejecuta.
@export var activo: bool = true

## Intervalo entre evaluaciones (segundos).
## Aumentar para optimizar rendimiento en IAs lejanas.
@export var intervalo_tick: float = 0.1

# --- ESTADO ---
var _pizarra: Dictionary = {} # Memoria compartida (Blackboard)
var _timer: Timer

func _ready() -> void:
	# Configurar timer interno
	_timer = Timer.new()
	_timer.wait_time = max(0.01, intervalo_tick)
	_timer.autostart = activo
	_timer.timeout.connect(_al_tick)
	add_child(_timer)

func _al_tick() -> void:
	if not activo or not arbol: return
	
	# Ejecutar árbol pasando el padre (Actor) y la memoria
	arbol.tick(get_parent(), _pizarra)

## Acceso directo a la memoria de la IA.
func obtener_pizarra() -> Dictionary:
	return _pizarra

## Establece un valor en la memoria de la IA.
func set_valor(clave: String, valor: Variant) -> void:
	_pizarra[clave] = valor

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not arbol:
		warnings.append("Asigna un Recurso 'RL_BTNode' (ej: RL_BTSelector) en la propiedad 'Arbol'.")
	return warnings
