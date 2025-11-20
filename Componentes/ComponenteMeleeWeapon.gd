# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMeleeWeapon.gd
## Sistema básico de ataque cuerpo a cuerpo.
##
## **Uso:** Gestiona la entrada de ataque, cooldowns, animaciones y activación/desactivación de Hitboxes.
## Funciona mejor si es hijo del personaje.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_MeleeWeapon
extends Node2D

# --- CONFIGURACIÓN ---

## Nombre de la acción en el Input Map (ej: "ui_accept" o "attack").
@export var accion_ataque: String = "ui_accept"

## Nodo Hitbox que se activará durante el ataque.
@export var hitbox: Area2D 

## Duración activa de la Hitbox (segundos).
@export var tiempo_activo: float = 0.2

## Tiempo total antes de poder atacar de nuevo (segundos).
@export var cooldown: float = 0.5

## Nombre de la animación a reproducir en el AnimatedSprite2D del padre.
@export var animacion_ataque: String = "attack"

## Nombre del sonido a reproducir (vía AudioManager).
@export var sonido_ataque: String = "swing"

# Estado interno
var puede_atacar: bool = true
var sprite: AnimatedSprite2D
var _timer_cooldown: Timer

func _ready() -> void:
	# Buscar sprite en el padre
	if get_parent():
		for child in get_parent().get_children():
			if child is AnimatedSprite2D:
				sprite = child
				break
		
	if hitbox:
		hitbox.monitorable = false
		hitbox.monitoring = false

	_timer_cooldown = Timer.new()
	_timer_cooldown.one_shot = true
	add_child(_timer_cooldown)

func _process(_delta: float) -> void:
	if puede_atacar and Input.is_action_just_pressed(accion_ataque):
		atacar()

func atacar() -> void:
	puede_atacar = false
	
	# Sonido
	if sonido_ataque != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_ataque)
		
	# Animación
	if sprite and sprite.sprite_frames and sprite.sprite_frames.has_animation(animacion_ataque):
		sprite.play(animacion_ataque)
		
	# Activar Hitbox
	if hitbox:
		hitbox.monitorable = true
		hitbox.monitoring = true
		
	# Esperar fin fase activa
	await get_tree().create_timer(tiempo_activo).timeout
	
	# Desactivar Hitbox (si aún existe)
	if is_instance_valid(hitbox):
		hitbox.monitorable = false
		hitbox.monitoring = false
		
	# Cooldown restante
	var tiempo_restante = max(0, cooldown - tiempo_activo)
	if tiempo_restante > 0:
		_timer_cooldown.start(tiempo_restante)
		await _timer_cooldown.timeout
	
	puede_atacar = true
	
	# Reset animación a idle si no se ha cambiado ya
	if sprite and sprite.animation == animacion_ataque:
		sprite.play("idle") # Asume que existe "idle"

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not hitbox:
		warnings.append("Debes asignar un nodo Hitbox para que el ataque haga daño.")
	return warnings
