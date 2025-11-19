# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteLookAt.gd
## Apunta hacia un objetivo.
##
## **Uso:** Añade este componente para que un objeto mire hacia otro.
## Útil para torretas y enemigos.
##
## **Casos de uso:**
## - Torretas que apuntan al jugador
## - Ojos que siguen al cursor
## - Enemigos que miran al objetivo
## - Flechas indicadoras
##
## **Nota:** Actualiza la rotación automáticamente cada frame.
@icon("res://icon.svg")
class_name ComponenteLookAt
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var mirar_al_mouse: bool = true
@export var objetivo_nodo: Node2D
@export var velocidad_giro: float = 10.0 # 0 = Instantáneo
@export var offset_grados: float = 0.0

var padre: Node2D

func _ready():
	padre = get_parent() as Node2D

func _process(delta):
	if not padre: return
	
	var destino = Vector2.ZERO
	
	if mirar_al_mouse:
		destino = padre.get_global_mouse_position()
	elif objetivo_nodo:
		destino = objetivo_nodo.global_position
	else:
		return
		
	var angulo_deseado = (destino - padre.global_position).angle() + deg_to_rad(offset_grados)
	
	if velocidad_giro <= 0:
		padre.rotation = angulo_deseado
	else:
		padre.rotation = lerp_angle(padre.rotation, angulo_deseado, velocidad_giro * delta)
