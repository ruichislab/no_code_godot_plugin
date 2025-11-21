# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSimpleAnimator.gd
## Controlador de animaciones automático basado en velocidad y estado.
##
## **Uso:** Conecta automáticamente el movimiento de un CharacterBody2D con un AnimatedSprite2D o AnimationPlayer.
## Detecta estados como: Reposo, Caminar, Correr, Saltar, Caer.
##
## **Requisito:** Debe ser hermano de un CharacterBody2D y de un nodo de animación.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_SimpleAnimator
extends Node

# --- CONFIGURACIÓN ---

## Tipo de nodo de animación a controlar.
@export_enum("AnimatedSprite2D", "AnimationPlayer") var tipo_animacion: int = 0

## Nodo de animación (Opcional, si vacío busca automáticamente).
@export var nodo_animacion: NodePath

## Velocidad mínima para considerar que está "caminando".
@export var umbral_movimiento: float = 10.0

## Nombres de las animaciones (personalizables).
@export_group("Nombres de Animaciones")
@export var anim_idle: String = "idle"
@export var anim_walk: String = "walk"
@export var anim_run: String = "run"
@export var anim_jump: String = "jump"
@export var anim_fall: String = "fall"

## Si es true, voltea el sprite (flip_h) automáticamente según la dirección X.
@export var voltear_sprite: bool = true

# --- ESTADO INTERNO ---
var actor: CharacterBody2D
var _animator_node: Node
var _last_anim: String = ""

func _ready() -> void:
	# Buscar actor (CharacterBody2D) en el padre
	actor = get_parent() as CharacterBody2D
	if not actor:
		push_warning("RL_SimpleAnimator debe ser hijo de un CharacterBody2D.")
		set_process(false)
		return

	# Buscar nodo de animación
	if nodo_animacion:
		_animator_node = get_node(nodo_animacion)
	else:
		# Búsqueda automática entre hermanos
		for child in actor.get_children():
			if tipo_animacion == 0 and child is AnimatedSprite2D:
				_animator_node = child
				break
			elif tipo_animacion == 1 and child is AnimationPlayer:
				_animator_node = child
				break

	if not _animator_node:
		push_warning("RL_SimpleAnimator no encontró un nodo de animación válido.")
		set_process(false)

func _process(_delta: float) -> void:
	if not actor or not _animator_node: return

	var anim_nueva = _determinar_animacion()

	# Reproducir solo si cambió
	if anim_nueva != _last_anim:
		_reproducir(anim_nueva)
		_last_anim = anim_nueva

	# Manejo de flip horizontal
	if voltear_sprite and actor.velocity.x != 0:
		var mirar_izquierda = actor.velocity.x < 0
		if _animator_node is AnimatedSprite2D or _animator_node is Sprite2D:
			_animator_node.flip_h = mirar_izquierda
		# Para AnimationPlayer, usualmente se voltea el Sprite padre o se usa track de flip,
		# pero aquí asumimos control directo de un Sprite hermano si existe, o ignoramos si es esqueleto complejo.
		# Intento genérico:
		var sprite = actor.get_node_or_null("Sprite2D")
		if sprite: sprite.flip_h = mirar_izquierda

func _determinar_animacion() -> String:
	# 1. Aéreo
	if not actor.is_on_floor():
		if actor.velocity.y < 0:
			return anim_jump
		else:
			return anim_fall

	# 2. Suelo
	if abs(actor.velocity.x) > umbral_movimiento:
		# Podríamos diferenciar walk/run por velocidad si tuviéramos acceso a la velocidad máxima
		# Por defecto usamos walk
		return anim_walk

	return anim_idle

func _reproducir(nombre: String) -> void:
	if tipo_animacion == 0: # AnimatedSprite2D
		var sprite = _animator_node as AnimatedSprite2D
		if sprite.sprite_frames.has_animation(nombre):
			sprite.play(nombre)
	elif tipo_animacion == 1: # AnimationPlayer
		var player = _animator_node as AnimationPlayer
		if player.has_animation(nombre):
			player.play(nombre)
