# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd
## Controlador avanzado de físicas para plataformas 2D.
##
## **Uso:** Implementa movimiento horizontal y salto con "game feel" (Tiempo Coyote, Buffer de Salto).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_PlatformerController
extends Node

# --- CONFIGURACIÓN ---

@export_group("Movimiento")
## Velocidad máxima horizontal (px/s).
@export var velocidad_maxima: float = 300.0
## Aceleración hasta velocidad máxima (px/s²).
@export var aceleracion: float = 1200.0
## Fricción en el suelo (frenado) (px/s²).
@export var friccion: float = 1000.0
## Fricción en el aire (control aéreo) (px/s²).
@export var friccion_aire: float = 200.0

@export_group("Salto")
## Altura máxima del salto en píxeles.
@export var altura_salto: float = 100.0
## Tiempo para llegar al punto más alto (segundos).
@export var tiempo_pico_salto: float = 0.4
## Tiempo para caer desde el punto más alto al suelo (segundos).
@export var tiempo_bajada_salto: float = 0.3
## Cantidad de saltos permitidos en el aire (doble salto = 1).
@export var saltos_extra: int = 0 

@export_group("Asistencias (Game Feel)")
## Tiempo de gracia para saltar tras caer de una plataforma (segundos).
@export var tiempo_coyote: float = 0.1
## Tiempo que se recuerda la pulsación de salto antes de tocar suelo (segundos).
@export var buffer_salto: float = 0.1

# --- VARIABLES INTERNAS (Calculadas) ---
var gravedad_subida: float
var gravedad_bajada: float
var velocidad_salto: float

var cuerpo: CharacterBody2D
var saltos_restantes: int = 0
var timer_coyote: float = 0.0
var timer_buffer_salto: float = 0.0

func _ready() -> void:
	cuerpo = get_parent() as CharacterBody2D
	if not cuerpo:
		push_error("RL_PlatformerController debe ser hijo de CharacterBody2D")
		set_physics_process(false)
		return
	
	_recalcular_fisicas()

func _recalcular_fisicas() -> void:
	velocidad_salto = ((2.0 * altura_salto) / tiempo_pico_salto) * -1.0
	gravedad_subida = ((-2.0 * altura_salto) / (tiempo_pico_salto * tiempo_pico_salto)) * -1.0
	gravedad_bajada = ((-2.0 * altura_salto) / (tiempo_bajada_salto * tiempo_bajada_salto)) * -1.0

func _physics_process(delta: float) -> void:
	if not cuerpo: return
	
	# 1. INPUTS
	var input_x = Input.get_axis("ui_left", "ui_right")
	var quiere_saltar = Input.is_action_just_pressed("ui_accept")
	var solto_salto = Input.is_action_just_released("ui_accept")
	
	# 2. TIMERS Y ESTADO
	if cuerpo.is_on_floor():
		saltos_restantes = saltos_extra
		timer_coyote = tiempo_coyote
	else:
		timer_coyote -= delta
		
	if quiere_saltar:
		timer_buffer_salto = buffer_salto
	else:
		timer_buffer_salto -= delta
	
	# 3. GRAVEDAD
	var gravedad_actual = gravedad_subida if cuerpo.velocity.y < 0 else gravedad_bajada
	cuerpo.velocity.y += gravedad_actual * delta
	
	# 4. MOVIMIENTO HORIZONTAL
	if input_x != 0:
		cuerpo.velocity.x = move_toward(cuerpo.velocity.x, input_x * velocidad_maxima, aceleracion * delta)
		_voltear_sprite(input_x)
	else:
		var fric = friccion if cuerpo.is_on_floor() else friccion_aire
		cuerpo.velocity.x = move_toward(cuerpo.velocity.x, 0, fric * delta)
	
	# 5. SALTO
	if timer_buffer_salto > 0:
		if timer_coyote > 0:
			_realizar_salto()
		elif saltos_restantes > 0:
			_realizar_salto()
			saltos_restantes -= 1
			
	# Salto variable
	if solto_salto and cuerpo.velocity.y < 0:
		cuerpo.velocity.y *= 0.5
		
	cuerpo.move_and_slide()

func _realizar_salto() -> void:
	cuerpo.velocity.y = velocidad_salto
	timer_buffer_salto = 0
	timer_coyote = 0

func _voltear_sprite(direccion_x: float) -> void:
	for child in cuerpo.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			if "flip_h" in child:
				child.flip_h = (direccion_x < 0)
			elif "scale" in child:
				child.scale.x = abs(child.scale.x) * sign(direccion_x)
			break

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is CharacterBody2D:
		warnings.append("El padre debe ser CharacterBody2D.")
	return warnings
