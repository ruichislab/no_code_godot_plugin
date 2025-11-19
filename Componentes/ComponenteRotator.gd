# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteRotator.gd
## Rotación constante automática.
##
## **Uso:** Añade este componente para rotar objetos continuamente.
##
## **Casos de uso:**
## - Monedas giratorias
## - Ventiladores
## - Sierras circulares
## - Planetas orbitando
## - Engranajes
##
## **Nota:** La velocidad se define en grados por segundo.
@icon("res://icon.svg")
class_name ComponenteRotator
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var velocidad_grados: float = 90.0
@export var aleatorizar_inicio: bool = false

var padre: Node2D

func _ready():
	padre = get_parent() as Node2D
	if not padre: return
	
	if aleatorizar_inicio:
		padre.rotation_degrees = randf_range(0, 360)

func _process(delta):
	if padre:
		padre.rotation_degrees += velocidad_grados * delta
