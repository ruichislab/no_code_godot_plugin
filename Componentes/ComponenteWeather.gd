# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteWeather.gd
## Sistema de Clima (Partículas).
##
## **Uso:** Lluvia, Nieve, Ceniza. Sigue automáticamente a la cámara.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Weather
extends Node2D

enum TipoClima { LLUVIA, NIEVE, CENIZA, POLVO }

# --- CONFIGURACIÓN ---
@export var tipo: TipoClima = TipoClima.LLUVIA:
	set(val):
		tipo = val
		if is_inside_tree(): _configurar_particulas()

@export var intensidad: int = 200:
	set(val):
		intensidad = val
		if _particulas: _particulas.amount = val

@export var color: Color = Color(0.8, 0.9, 1.0, 0.7):
	set(val):
		color = val
		if _particulas: _particulas.color = val

@export var velocidad_viento: Vector2 = Vector2(-50, 200)

# --- INTERNO ---
var _particulas: CPUParticles2D

func _ready() -> void:
	_particulas = CPUParticles2D.new()
	_particulas.name = "ParticulasClima"
	add_child(_particulas)
	
	_configurar_particulas()

func _process(_delta: float) -> void:
	# Seguir a la cámara para simular efecto global
	var viewport = get_viewport()
	if viewport and viewport.get_camera_2d():
		global_position = viewport.get_camera_2d().get_screen_center_position()

func _configurar_particulas() -> void:
	if not _particulas: return

	_particulas.amount = intensidad
	_particulas.lifetime = 2.0
	_particulas.preprocess = 2.0 # Iniciar lleno
	_particulas.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	# Cubrir un área grande (ej: 1920x1080 + margen)
	_particulas.emission_rect_extents = Vector2(960, 540)
	_particulas.color = color
	
	match tipo:
		TipoClima.LLUVIA:
			_particulas.direction = Vector2(0, 1)
			_particulas.spread = 5.0
			_particulas.gravity = velocidad_viento
			_particulas.initial_velocity_min = 400
			_particulas.initial_velocity_max = 600
			_particulas.scale_amount_min = 2.0
			_particulas.scale_amount_max = 3.0
			
		TipoClima.NIEVE:
			_particulas.direction = Vector2(0, 1)
			_particulas.spread = 45.0
			_particulas.gravity = velocidad_viento * 0.2 # Nieve cae más lento
			_particulas.initial_velocity_min = 50
			_particulas.initial_velocity_max = 150
			_particulas.scale_amount_min = 4.0
			_particulas.scale_amount_max = 8.0
			_particulas.angular_velocity_min = -50
			_particulas.angular_velocity_max = 50
			
		TipoClima.CENIZA:
			_particulas.direction = Vector2(0, -1) # Sube un poco o flota
			_particulas.spread = 180.0
			_particulas.gravity = Vector2(0, 10)
			_particulas.initial_velocity_min = 10
			_particulas.initial_velocity_max = 30
			_particulas.scale_amount_min = 2.0
			_particulas.scale_amount_max = 4.0
