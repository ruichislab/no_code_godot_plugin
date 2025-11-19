# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDash.gd
## Habilidad de dash/roll.
##
## **Uso:** Añade este componente al jugador para permitir esquivas rápidas.
## Mueve al personaje a alta velocidad en la dirección actual.
##
## **Casos de uso:**
## - Esquivas (Dark Souls)
## - Dash (Celeste)
## - Teletransporte corto
## - Movimiento táctico
##
## **Requisito:** El padre debe ser CharacterBody2D.
@icon("res://icon.svg")
class_name ComponenteDash
extends Node
const _tool_context = "RuichisLab/Nodos"

## Acción del Input Map para activar el dash.
@export var accion_dash: String = "ui_focus_next" 
## Velocidad del impulso.
@export var velocidad_dash: float = 800.0
## Duración del dash en segundos.
@export var duracion: float = 0.2
## Tiempo de espera entre usos.
@export var cooldown: float = 1.0
## Sonido al activar.
@export var sonido_dash: String = "dash"

var puede_hacer_dash: bool = true
var padre: CharacterBody2D
var hurtbox: Area2D

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _ready():
	padre = get_parent() as CharacterBody2D
	if not padre:
		push_error("NC_Dash debe ser hijo de un CharacterBody2D.")
		return
		
	# Buscar Hurtbox para invulnerabilidad
	for child in padre.get_children():
		if child is ComponenteHurtbox:
			hurtbox = child
			break

func _process(delta):
	if not padre: return
	
	if puede_hacer_dash and Input.is_action_just_pressed(accion_dash):
		iniciar_dash()

func iniciar_dash():
	puede_hacer_dash = false
	
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido_dash)
		elif sm.has_method("reproducir_sonido") and typeof(sonido_dash) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido_dash)
		
	# Dirección del dash
	var dir = padre.velocity.normalized()
	if dir == Vector2.ZERO:
		# Si está quieto, dash hacia donde mira (sprite) o derecha por defecto
		dir = Vector2.RIGHT 
	
	# Aplicar velocidad
	# Nota: Esto asume que el controlador de movimiento respeta la velocidad actual
	# O sobreescribe la velocidad durante el dash.
	# Una forma simple es forzar la posición o velocidad durante un tiempo.
	
	var tween = create_tween()
	# Mantener velocidad alta durante el dash
	padre.velocity = dir * velocidad_dash
	
	# Invulnerabilidad
	if hurtbox:
		hurtbox.monitorable = false
		hurtbox.monitoring = false
		
	# Efecto visual (Ghost trail sería ideal, pero simple color por ahora)
	var sprite = padre.get_node_or_null("AnimatedSprite2D")
	if sprite:
		sprite.modulate.a = 0.5
	
	await get_tree().create_timer(duracion).timeout
	
	# Fin del dash
	padre.velocity = Vector2.ZERO # Frenar un poco
	if sprite:
		sprite.modulate.a = 1.0
		
	if hurtbox:
		hurtbox.monitorable = true
		hurtbox.monitoring = true
		
	await get_tree().create_timer(cooldown).timeout
	puede_hacer_dash = true
