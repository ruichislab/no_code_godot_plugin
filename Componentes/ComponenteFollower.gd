# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteFollower.gd
## Comportamiento de seguimiento simple hacia un objetivo.
##
## **Uso:** Añadir como hijo de un CharacterBody2D (con física) o Node2D (sin física).
## Busca automáticamente nodos en el grupo especificado y los persigue.
##
## **Casos de uso:**
## - Enemigos agresivos.
## - Mascotas o acompañantes.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Follower
extends Node

# --- CONFIGURACIÓN ---

## Nombre del grupo al que pertenece el objetivo (ej: "jugador").
@export var grupo_objetivo: String = "jugador"

## Velocidad de persecución (px/s).
@export var velocidad: float = 150.0

## Distancia de detención (para no solaparse).
@export var distancia_detencion: float = 50.0

## Distancia máxima para empezar a seguir (0 = infinito).
@export var distancia_activacion: float = 300.0

## Si es true, usa move_and_slide() (requiere CharacterBody2D). Si false, mueve posición directamente.
@export var usar_fisicas: bool = true

# Referencias
var padre: Node2D
var objetivo: Node2D

func _ready() -> void:
	padre = get_parent() as Node2D
	if not padre:
		push_error("RL_Follower debe ser hijo de un Node2D.")
		set_physics_process(false)
		return

func _physics_process(delta: float) -> void:
	if not is_instance_valid(objetivo):
		_buscar_objetivo()
		return

	var distancia = padre.global_position.distance_to(objetivo.global_position)
	
	# Chequeo de rango de activación
	if distancia_activacion > 0 and distancia > distancia_activacion:
		# Objetivo muy lejos, detenerse
		_detenerse(delta)
		return

	# Chequeo de distancia de parada
	if distancia > distancia_detencion:
		var direccion = (objetivo.global_position - padre.global_position).normalized()
		
		if usar_fisicas and padre is CharacterBody2D:
			padre.velocity = direccion * velocidad
			padre.move_and_slide()
		else:
			padre.global_position += direccion * velocidad * delta
			
		# Orientación básica (Flip horizontal)
		if direccion.x != 0:
			padre.scale.x = abs(padre.scale.x) * sign(direccion.x)
	else:
		_detenerse(delta)

func _detenerse(delta: float) -> void:
	if usar_fisicas and padre is CharacterBody2D:
		padre.velocity = padre.velocity.move_toward(Vector2.ZERO, 1000 * delta)
		padre.move_and_slide()

func _buscar_objetivo() -> void:
	# Intenta encontrar un objetivo vivo en el grupo
	var nodos = get_tree().get_nodes_in_group(grupo_objetivo)
	if not nodos.is_empty():
		# Tomar el primero (se podría mejorar para tomar el más cercano)
		objetivo = nodos[0]

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is Node2D:
		warnings.append("El padre debe ser un Node2D.")
	if usar_fisicas and not get_parent() is CharacterBody2D:
		warnings.append("Modo 'usar_fisicas' activado pero el padre no es CharacterBody2D.")
	return warnings
