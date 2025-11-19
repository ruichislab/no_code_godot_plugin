# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTopDownController.gd
## Controlador de movimiento top-down.
##
## **Uso:** Añade este componente para movimiento estilo Zelda/Hotline Miami.
## Incluye aceleración, fricción y animaciones.
##
## **Casos de uso:**
## - Juegos estilo Zelda
## - Twin-stick shooters
## - RPGs de acción
## - Juegos de supervivencia
##
## **Requisito:** El padre debe ser CharacterBody2D.
class_name ComponenteTopDownController
extends Node
const _tool_context = "RuichisLab/Nodos"

## Velocidad máxima en píxeles/segundo.
@export var velocidad_maxima: float = 200.0
## Aceleración para alcanzar la velocidad máxima.
@export var aceleracion: float = 1500.0
## Fricción para detenerse.
@export var friccion: float = 1000.0
## Si es true, busca un AnimatedSprite2D y cambia animaciones.
@export var animar_sprite: bool = true

var padre: CharacterBody2D
var sprite: AnimatedSprite2D

func _ready():
	padre = get_parent() as CharacterBody2D
	if not padre:
		push_error("NC_TopDownController debe ser hijo de un CharacterBody2D.")
		return
		
	if animar_sprite:
		# Buscar AnimatedSprite2D
		for child in padre.get_children():
			if child is AnimatedSprite2D:
				sprite = child
				break

func _physics_process(delta):
	if not padre: return
	
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		# Acelerar
		padre.velocity = padre.velocity.move_toward(input_vector * velocidad_maxima, aceleracion * delta)
		_actualizar_animacion(input_vector)
	else:
		# Frenar
		padre.velocity = padre.velocity.move_toward(Vector2.ZERO, friccion * delta)
		if animar_sprite and sprite:
			if sprite.animation.begins_with("walk") or sprite.animation.begins_with("run"):
				sprite.play("idle") # O la animación de reposo correspondiente
	
	padre.move_and_slide()

func _actualizar_animacion(vector: Vector2):
	if not animar_sprite or not sprite: return
	
	# Lógica simple de 4 direcciones
	var anim = "walk"
	
	if abs(vector.x) > abs(vector.y):
		if vector.x > 0:
			sprite.flip_h = false
			# sprite.play(anim + "_right") # Si tienes animaciones separadas
		else:
			sprite.flip_h = true
			# sprite.play(anim + "_left")
	
	# Si tienes animaciones específicas, descomenta esto:
	# elif vector.y > 0: sprite.play(anim + "_down")
	# else: sprite.play(anim + "_up")
	
	if sprite.animation != anim:
		sprite.play(anim)