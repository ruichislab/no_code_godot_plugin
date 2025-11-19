# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMeleeWeapon.gd
## Arma de combate cuerpo a cuerpo.
##
## **Uso:** Añade este componente al jugador para crear ataques melee.
## Activa un Hitbox cuando se presiona el botón de ataque.
##
## **Casos de uso:**
## - Espadas
## - Hachas
## - Puños
## - Lanzas
## - Martillos
##
## **Requisito:** Debe tener un hijo Hitbox. Requiere AnimationPlayer para animaciones.
@icon("res://icon.svg")
class_name ComponenteMeleeWeapon
extends Node2D
const _tool_context = "RuichisLab/Nodos"

## Acción del Input Map para atacar.
@export var accion_ataque: String = "ui_accept"
## Referencia al área de daño (NC_Hitbox).
@export var hitbox: Area2D 
## Duración de la fase activa del ataque.
@export var tiempo_ataque: float = 0.2 
## Tiempo de espera entre ataques.
@export var cooldown: float = 0.5
## Nombre de la animación a reproducir.
@export var animacion_ataque: String = "attack"
## Sonido al atacar.
@export var sonido_ataque: String = "swing"

var puede_atacar: bool = true
var sprite: AnimatedSprite2D

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _ready():
	# Buscar sprite en el padre (Jugador)
	var padre = get_parent()
	for child in padre.get_children():
		if child is AnimatedSprite2D:
			sprite = child

			break
		
	if hitbox:
		hitbox.monitorable = false # Desactivado por defecto
		hitbox.monitoring = false

func _process(delta):
	if puede_atacar and Input.is_action_just_pressed(accion_ataque):
		atacar()

func atacar():
	puede_atacar = false
	
	print("Ataque iniciado!")
	
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido_ataque)
		elif sm.has_method("reproducir_sonido") and typeof(sonido_ataque) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido_ataque)
		
	if sprite and sprite.sprite_frames.has_animation(animacion_ataque):
		sprite.play(animacion_ataque)
		
	# Activar Hitbox
	if hitbox:
		hitbox.monitorable = true
		hitbox.monitoring = true
		
	# Esperar duración del ataque
	await get_tree().create_timer(tiempo_ataque).timeout
	
	# Desactivar Hitbox
	if hitbox:
		hitbox.monitorable = false
		hitbox.monitoring = false
		
	# Esperar cooldown
	await get_tree().create_timer(cooldown - tiempo_ataque).timeout
	
	puede_atacar = true
	
	# Volver a idle si no se está moviendo (opcional, depende del controller)
	if sprite and sprite.animation == animacion_ataque:
		sprite.play("idle")
