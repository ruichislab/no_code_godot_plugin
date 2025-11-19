# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteKnockback.gd
## Empuje al recibir daño.
##
## **Uso:** Añade este componente para que el personaje retroceda al ser golpeado.
## Mejora el feedback visual del combate.
##
## **Casos de uso:**
## - Jugador al recibir daño
## - Enemigos al ser golpeados
## - Efectos de explosiones
## - Impactos de proyectiles
##
## **Requisito:** El padre debe ser CharacterBody2D.
@icon("res://icon.svg")
class_name ComponenteKnockback
extends Node
const _tool_context = "RuichisLab/Nodos"

## Fuerza del empuje.
@export var fuerza: float = 500.0
## Duración del efecto de empuje.
@export var duracion: float = 0.1

var padre: CharacterBody2D
var hurtbox: Area2D

func _ready():
	padre = get_parent() as CharacterBody2D
	if not padre:
		push_warning("NC_Knockback debe ser hijo de un CharacterBody2D.")
		return
		
	# Buscar Hurtbox
	for child in padre.get_children():
		if child is ComponenteHurtbox:
			hurtbox = child
			break
			
	if hurtbox:
		hurtbox.dano_recibido.connect(_on_dano_recibido)

func _on_dano_recibido(cantidad, origen):
	if not padre: return
	
	var direccion = Vector2.ZERO
	if origen:
		direccion = (padre.global_position - origen.global_position).normalized()
	else:
		# Dirección aleatoria si no hay origen
		direccion = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
	aplicar_knockback(direccion)

func aplicar_knockback(dir: Vector2):
	# Desactivar control temporalmente si es posible (requeriría señal o variable en controller)
	# Por ahora, forzamos velocidad
	padre.velocity = dir * fuerza
	
	# Un pequeño tween para decaer la velocidad
	var tween = create_tween()
	tween.tween_property(padre, "velocity", Vector2.ZERO, duracion)
