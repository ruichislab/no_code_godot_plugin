# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteFollower.gd
## Seguimiento automático de un objetivo.
##
## **Uso:** Añade este componente para que un objeto siga a otro.
## Ideal para enemigos perseguidores o compañeros.
##
## **Casos de uso:**
## - Enemigos que persiguen al jugador
## - Mascotas que siguen
## - Proyectiles teledirigidos
## - Compañeros de equipo
##
## **Requisito:** El padre debe ser CharacterBody2D.
@icon("res://icon.svg")
class_name ComponenteFollower
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var grupo_objetivo: String = "jugador"
@export var velocidad: float = 150.0
@export var distancia_minima: float = 50.0
@export var suavizado: float = 5.0

var padre: Node2D
var objetivo: Node2D

func _ready():
	padre = get_parent() as Node2D
	
	# Buscar objetivo inicial
	await get_tree().process_frame
	var nodos = get_tree().get_nodes_in_group(grupo_objetivo)
	if not nodos.is_empty():
		objetivo = nodos[0]

func _process(delta):
	if not padre or not is_instance_valid(objetivo): return
	
	var distancia = padre.global_position.distance_to(objetivo.global_position)
	
	if distancia > distancia_minima:
		var direccion = (objetivo.global_position - padre.global_position).normalized()
		
		# Movimiento suavizado
		var velocidad_actual = velocidad
		if suavizado > 0:
			# Lerp para efecto "elástico"
			padre.global_position = padre.global_position.lerp(objetivo.global_position, suavizado * delta)
		else:
			# Movimiento lineal constante
			padre.global_position += direccion * velocidad * delta
			
		# Girar sprite hacia objetivo
		if direccion.x != 0:
			padre.scale.x = abs(padre.scale.x) * sign(direccion.x)
