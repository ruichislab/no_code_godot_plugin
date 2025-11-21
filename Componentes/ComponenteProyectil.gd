# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteProyectil.gd
## Controlador avanzado de proyectiles (Balas, Misiles, Magia).
##
## **Uso:** Mueve al padre. Integración nativa con `PoolManager` y `RL_Hitbox`.
## **Características:** Rebote, Perforación, Seguimiento (Homing).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Projectile
extends Node2D

# --- CONFIGURACIÓN ---

@export_group("Movimiento")
## Velocidad en pixeles/segundo.
@export var velocidad: float = 400.0
## Aceleración (puedes usar valores negativos para frenar).
@export var aceleracion: float = 0.0
## Tiempo de vida máximo en segundos.
@export var tiempo_vida: float = 3.0

@export_group("Comportamiento")
## Cuántas veces puede rebotar en paredes antes de destruirse.
@export var rebotes_maximos: int = 0
## Cuántos enemigos puede atravesar.
@export var perforaciones: int = 0
## Si es true, rota el sprite hacia la dirección de movimiento.
@export var rotar_sprite: bool = true

@export_group("Seguimiento (Homing)")
## Nodo objetivo a perseguir.
@export var objetivo: Node2D
## Fuerza de giro (grados/segundo). 0 desactiva el homing.
@export var fuerza_giro: float = 0.0

@export_group("Impacto")
## Escena a instanciar al morir/impactar.
@export var efecto_impacto: PackedScene

# --- ESTADO ---
var _velocidad_actual: float
var _tiempo_restante: float
var _rebotes: int
var _perforaciones: int
var _padre_node: Node2D
var _velocity_vec: Vector2

func _ready() -> void:
	_padre_node = get_parent() as Node2D
	if not _padre_node:
		set_physics_process(false)
		return

	# Intentar auto-conectar con Hitbox hermano
	for child in _padre_node.get_children():
		if child is RL_Hitbox:
			child.impacto_exitoso.connect(_al_impactar)
			# Desactivar destrucción automática del Hitbox para gestionarla aquí
			child.destruir_al_impactar = false
	
	_on_spawn() # Inicializar si no se usa PoolManager

func _on_spawn() -> void:
	_velocidad_actual = velocidad
	_tiempo_restante = tiempo_vida
	_rebotes = 0
	_perforaciones = 0
	# Vector inicial basado en rotación del padre
	_velocity_vec = Vector2.RIGHT.rotated(_padre_node.rotation) * _velocidad_actual

func _physics_process(delta: float) -> void:
	if _tiempo_restante > 0:
		_tiempo_restante -= delta
		if _tiempo_restante <= 0:
			_destruir()
			return

	# Aceleración
	if aceleracion != 0:
		_velocidad_actual += aceleracion * delta
	
	# Homing
	if fuerza_giro > 0 and is_instance_valid(objetivo):
		var dir_objetivo = (_padre_node.global_position.direction_to(objetivo.global_position))
		var dir_actual = _velocity_vec.normalized()
		# Interpolación angular simple
		var nuevo_dir = dir_actual.slerp(dir_objetivo, (fuerza_giro * delta) / 10.0).normalized()
		_velocity_vec = nuevo_dir * _velocidad_actual
	else:
		_velocity_vec = _velocity_vec.normalized() * _velocidad_actual

	# Movimiento
	# Si el padre es CharacterBody2D, usamos move_and_slide para rebotes físicos reales
	if _padre_node is CharacterBody2D:
		_padre_node.velocity = _velocity_vec
		_padre_node.move_and_slide()

		# Detectar colisión con pared (rebote físico)
		if _padre_node.get_slide_collision_count() > 0:
			var col = _padre_node.get_slide_collision(0)
			if rebotes_maximos > _rebotes:
				_rebotes += 1
				_velocity_vec = _velocity_vec.bounce(col.get_normal())
				_padre_node.rotation = _velocity_vec.angle()
			else:
				_destruir()
	else:
		# Movimiento manual para Area2D/Node2D
		_padre_node.global_position += _velocity_vec * delta

	if rotar_sprite:
		_padre_node.rotation = _velocity_vec.angle()

func _al_impactar(_objetivo: Area2D) -> void:
	if perforaciones > _perforaciones:
		_perforaciones += 1
		# No destruir, seguir
	else:
		_destruir()

func _destruir() -> void:
	if efecto_impacto:
		var fx = efecto_impacto.instantiate()
		fx.global_position = _padre_node.global_position
		fx.rotation = _padre_node.rotation
		get_tree().current_scene.add_child(fx)

	if Engine.has_singleton("PoolManager") and _padre_node.has_meta("pool_id"):
		Engine.get_singleton("PoolManager").call("reciclar", _padre_node)
	else:
		_padre_node.queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is Node2D:
		warnings.append("El padre debe ser Node2D (preferiblemente CharacterBody2D o Area2D).")
	return warnings
