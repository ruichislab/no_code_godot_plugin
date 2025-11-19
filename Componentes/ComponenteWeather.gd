# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteWeather.gd
## Sistema de clima (lluvia, nieve).
##
## **Uso:** Añade este componente para crear efectos de clima.
## Genera partículas de lluvia/nieve automáticamente.
##
## **Casos de uso:**
## - Lluvia
## - Nieve
## - Niebla
## - Tormentas
##
## **Requisito:** Debe heredar de Node2D.
class_name ComponenteWeather
extends Node2D
const _tool_context = "RuichisLab/Nodos"

enum TipoClima { LLUVIA, NIEVE, CENIZA, POLVO }
@export var tipo: TipoClima = TipoClima.LLUVIA
@export var intensidad: int = 100 # Cantidad de partículas
@export var color: Color = Color(0.7, 0.8, 1.0, 0.8)
@export var velocidad_viento: Vector2 = Vector2(-50, 200)

var particulas: CPUParticles2D

func _ready():
	particulas = CPUParticles2D.new()
	add_child(particulas)
	
	particulas.amount = intensidad
	particulas.lifetime = 2.0
	particulas.preprocess = 2.0 # Empezar ya lleno
	particulas.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particulas.emission_rect_extents = Vector2(600, 400) # Cubrir pantalla 1080p aprox
	particulas.gravity = Vector2.ZERO
	particulas.color = color
	
	match tipo:
		TipoClima.LLUVIA:
			particulas.direction = Vector2(0, 1)
			particulas.spread = 5.0
			particulas.initial_velocity_min = 400
			particulas.initial_velocity_max = 600
			particulas.scale_amount_min = 2.0
			particulas.scale_amount_max = 3.0
			# Dibujar líneas para lluvia
			# Nota: CPUParticles2D no soporta trails nativos fácilmente sin textura, 
			# usaremos cuadrados estirados
			
		TipoClima.NIEVE:
			particulas.direction = Vector2(0, 1)
			particulas.spread = 45.0
			particulas.initial_velocity_min = 50
			particulas.initial_velocity_max = 100
			particulas.scale_amount_min = 3.0
			particulas.scale_amount_max = 6.0
			particulas.angular_velocity_min = -50
			particulas.angular_velocity_max = 50
			
	# Aplicar viento
	particulas.gravity = velocidad_viento

func _process(delta):
	# Seguir a la cámara
	var cam = get_viewport().get_camera_2d()
	if cam:
		global_position = cam.get_screen_center_position()