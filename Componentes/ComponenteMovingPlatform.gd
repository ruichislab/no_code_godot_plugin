# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMovingPlatform.gd
## Plataforma móvil automática.
##
## **Uso:** Añade este componente para crear plataformas que se mueven.
## Define waypoints y la plataforma se mueve entre ellos.
##
## **Casos de uso:**
## - Plataformas móviles
## - Ascensores
## - Trenes
## - Plataformas de puzzle
##
## **Nota:** Define los waypoints como nodos Marker2D hijos.
@icon("res://icon.svg")
class_name ComponenteMovingPlatform
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var puntos: Array[Vector2]
@export var velocidad: float = 100.0
@export var esperar_en_puntos: float = 1.0
@export var ciclico: bool = true
@export var suave: bool = true

var padre: Node2D
var indice_actual: int = 0

func _ready():
	padre = get_parent() as Node2D
	if puntos.is_empty():
		# Si no hay puntos, usar la posición actual y una relativa por defecto
		puntos.append(Vector2.ZERO) # Relativo al padre
		puntos.append(Vector2(0, -200))
		
	# Convertir puntos a globales si son relativos (opcional, pero más fácil para el usuario si son relativos al inicio)
	# Asumiremos que los puntos son offsets desde la posición inicial para facilitar el diseño
	var pos_inicial = padre.global_position
	for i in range(puntos.size()):
		puntos[i] = pos_inicial + puntos[i]
		
	_mover_al_siguiente()

func _mover_al_siguiente():
	if not padre: return
	
	indice_actual = (indice_actual + 1) % puntos.size()
	var destino = puntos[indice_actual]
	var distancia = padre.global_position.distance_to(destino)
	var tiempo = distancia / velocidad
	
	var tween = create_tween()
	if suave:
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.set_trans(Tween.TRANS_LINEAR)
		
	tween.tween_property(padre, "global_position", destino, tiempo)
	tween.tween_callback(_esperar)

func _esperar():
	await get_tree().create_timer(esperar_en_puntos).timeout
	_mover_al_siguiente()
