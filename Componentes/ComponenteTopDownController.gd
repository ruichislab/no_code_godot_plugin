# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTopDownController.gd
## Controlador de movimiento top-down para CharacterBody2D.
##
## Provee movimiento suave en 8 direcciones con aceleración y fricción.
## Puede controlar automáticamente las animaciones de un AnimatedSprite2D hijo.
##
## **Casos de uso:**
## - RPGs de acción (Zelda-like)
## - Shooters
## - Juegos de aventura
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_TopDownController
extends Node

## Velocidad máxima en píxeles/segundo.
@export var velocidad_maxima: float = 200.0
## Aceleración para alcanzar la velocidad máxima (px/s²).
@export var aceleracion: float = 1500.0
## Fricción para detenerse (px/s²).
@export var friccion: float = 1000.0
## Si es true, busca un AnimatedSprite2D hermano y cambia animaciones automáticamente.
@export var animar_sprite: bool = true
## Nombre de la animación de caminar.
@export var animacion_caminar: String = "walk"
## Nombre de la animación de reposo.
@export var animacion_reposo: String = "idle"

# Referencias internas
var padre: CharacterBody2D
var sprite: AnimatedSprite2D

func _ready() -> void:
	padre = get_parent() as CharacterBody2D
	if not padre:
		push_error("RL_TopDownController debe ser hijo de un CharacterBody2D.")
		return
		
	if animar_sprite:
		# Buscar AnimatedSprite2D en los hijos del padre (hermanos de este nodo)
		for child in padre.get_children():
			if child is AnimatedSprite2D:
				sprite = child
				break

func _physics_process(delta: float) -> void:
	if not padre: return
	
	# Obtener input normalizado
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		# Acelerar
		padre.velocity = padre.velocity.move_toward(input_vector * velocidad_maxima, aceleracion * delta)
		_actualizar_animacion(input_vector)
	else:
		# Frenar
		padre.velocity = padre.velocity.move_toward(Vector2.ZERO, friccion * delta)

		# Volver a reposo si es necesario
		if animar_sprite and sprite:
			if sprite.animation.begins_with(animacion_caminar):
				sprite.play(animacion_reposo)
	
	padre.move_and_slide()

func _actualizar_animacion(vector: Vector2) -> void:
	if not animar_sprite or not sprite: return
	
	var anim: String = animacion_caminar
	
	# Voltear sprite horizontalmente según dirección
	if abs(vector.x) > 0:
		sprite.flip_h = (vector.x < 0)
	
	# Lógica para animaciones direccionales específicas (opcional)
	# if vector.y > 0: anim += "_down"
	# elif vector.y < 0: anim += "_up"
	
	if sprite.animation != anim:
		sprite.play(anim)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is CharacterBody2D:
		warnings.append("Este nodo debe ser hijo de un CharacterBody2D para funcionar.")
	return warnings
