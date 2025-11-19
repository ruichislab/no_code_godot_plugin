# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteBouncer.gd
## Plataforma que impulsa hacia arriba.
##
## **Uso:** Añade este componente para crear trampolines.
## Impulsa al jugador hacia arriba al tocarlo.
##
## **Casos de uso:**
## - Trampolines
## - Plataformas de impulso
## - Geisers
## - Catapultas
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteBouncer
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var fuerza: Vector2 = Vector2(0, -1000)
@export var sonido_salto: String = "spring_jump"
@export var animacion_activacion: String = "bounce"

var sprite: AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Buscar sprite opcional para animar
	for child in get_children():
		if child is AnimatedSprite2D:
			sprite = child
			break

func _on_body_entered(body):
	var impulsado = false
	
	if body is CharacterBody2D:
		body.velocity = fuerza
		# Resetear 'on_floor' si es posible (depende del controlador)
		if body.has_method("forzar_salto"):
			body.forzar_salto(fuerza)
		impulsado = true
		
	elif body is RigidBody2D:
		body.apply_central_impulse(fuerza)
		impulsado = true
		
	if impulsado:
		activar_efectos()

func activar_efectos():
	if SoundManager:
		SoundManager.play_sfx(sonido_salto)
		
	if sprite and sprite.sprite_frames.has_animation(animacion_activacion):
		sprite.play(animacion_activacion)
		# Volver a idle al terminar (si no es loop)
		if not sprite.is_connected("animation_finished", _on_anim_finished):
			sprite.animation_finished.connect(_on_anim_finished)

func _on_anim_finished():
	if sprite.animation == animacion_activacion:
		sprite.play("idle")
