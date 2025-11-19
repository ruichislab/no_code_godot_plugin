# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd
## Controlador de movimiento para plataformas 2D.
##
## **Uso:** Añade este componente para crear controles estilo Celeste/Mario.
## Incluye coyote time, jump buffer y salto variable.
##
## **Casos de uso:**
## - Plataformas 2D
## - Metroidvanias
## - Precision platformers
##
## **Requisito:** El padre debe ser CharacterBody2D.
class_name ComponentePlatformerController
extends Node
const _tool_context = "RuichisLab/Nodos"

@export_group("Movimiento")
## Velocidad máxima horizontal.
@export var velocidad_maxima: float = 300.0
## Aceleración hasta velocidad máxima.
@export var aceleracion: float = 1200.0
## Fricción en el suelo (frenado).
@export var friccion: float = 1000.0
## Fricción en el aire (control aéreo).
@export var friccion_aire: float = 200.0

@export_group("Salto")
## Altura máxima del salto en píxeles.
@export var altura_salto: float = 100.0
## Tiempo para llegar al punto más alto (segundos).
@export var tiempo_pico_salto: float = 0.4
## Tiempo para caer desde el punto más alto (segundos).
@export var tiempo_bajada_salto: float = 0.3
## Cantidad de saltos en el aire permitidos.
@export var saltos_extra: int = 0 

@export_group("Asistencias (Game Feel)")
## Tiempo de gracia para saltar tras caer de una plataforma.
@export var coyote_time: float = 0.1
## Tiempo que se recuerda la pulsación de salto antes de tocar suelo.
@export var jump_buffer: float = 0.1

# Variables calculadas
var gravedad_subida: float
var gravedad_bajada: float
var velocidad_salto: float

var cuerpo: CharacterBody2D
var saltos_restantes: int
var tiempo_coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _ready():
	cuerpo = get_parent() as CharacterBody2D
	if not cuerpo:
		push_error("NC_PlatformerController debe ser hijo de CharacterBody2D")
		return
	
	_recalcular_fisicas()

func _recalcular_fisicas():
	velocidad_salto = ((2.0 * altura_salto) / tiempo_pico_salto) * -1.0
	gravedad_subida = ((-2.0 * altura_salto) / (tiempo_pico_salto * tiempo_pico_salto)) * -1.0
	gravedad_bajada = ((-2.0 * altura_salto) / (tiempo_bajada_salto * tiempo_bajada_salto)) * -1.0

func _physics_process(delta):
	if not cuerpo: return
	
	# 1. INPUTS
	var input_x = Input.get_axis("ui_left", "ui_right")
	var quiere_saltar = Input.is_action_just_pressed("ui_accept")
	var solto_salto = Input.is_action_just_released("ui_accept")
	
	# 2. TIMERS
	if cuerpo.is_on_floor():
		saltos_restantes = saltos_extra
		tiempo_coyote_timer = coyote_time
	else:
		tiempo_coyote_timer -= delta
		
	if quiere_saltar:
		jump_buffer_timer = jump_buffer
	else:
		jump_buffer_timer -= delta
	
	# 3. GRAVEDAD
	var gravedad_actual = gravedad_subida if cuerpo.velocity.y < 0 else gravedad_bajada
	cuerpo.velocity.y += gravedad_actual * delta
	
	# 4. MOVIMIENTO HORIZONTAL
	if input_x != 0:
		cuerpo.velocity.x = move_toward(cuerpo.velocity.x, input_x * velocidad_maxima, aceleracion * delta)
	else:
		var fric = friccion if cuerpo.is_on_floor() else friccion_aire
		cuerpo.velocity.x = move_toward(cuerpo.velocity.x, 0, fric * delta)
	
	# 5. SALTO
	if jump_buffer_timer > 0 and (tiempo_coyote_timer > 0 or saltos_restantes > 0):
		cuerpo.velocity.y = velocidad_salto
		jump_buffer_timer = 0
		
		if tiempo_coyote_timer <= 0: # Fue un salto aéreo
			saltos_restantes -= 1
			
	# Salto variable (soltar botón para caer antes)
	if solto_salto and cuerpo.velocity.y < 0:
		cuerpo.velocity.y *= 0.5
		
	cuerpo.move_and_slide()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not get_parent() is CharacterBody2D:
		warnings.append("Este componente debe ser hijo de un CharacterBody2D para funcionar.")
	return warnings