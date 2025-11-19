# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePushable.gd
## Objeto empujable (puzzles).
##
## **Uso:** Añade este componente a objetos que pueden ser empujados.
## El jugador puede moverlos aplicando fuerza.
##
## **Casos de uso:**
## - Cajas de puzzle
## - Bloques de hielo
## - Piedras empujables
## - Puzzles de Sokoban
##
## **Requisito:** El padre debe ser RigidBody2D o CharacterBody2D.
@icon("res://icon.svg")
class_name ComponentePushable
extends Node
const _tool_context = "RuichisLab/Nodos"

# Hace que un RigidBody2D o CharacterBody2D sea empujable.

## Fuerza aplicada al objeto al ser empujado.
@export var fuerza_empuje: float = 50.0

var padre: Node2D

func _ready():
	padre = get_parent() as Node2D

# Llamar a esto desde el jugador cuando colisiona
# O usar un Area2D para detectar
func empujar(direccion: Vector2):
	if padre is RigidBody2D:
		padre.apply_central_impulse(direccion * fuerza_empuje)
	elif padre is CharacterBody2D:
		padre.velocity = direccion * fuerza_empuje
		padre.move_and_slide()
