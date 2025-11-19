# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCarController.gd
## Controlador de vehículo arcade.
##
## **Uso:** Añade este componente para crear controles de coche arcade.
## Incluye aceleración, frenado y derrape.
##
## **Casos de uso:**
## - Juegos de carreras
## - Kart racing
## - Top-down racing
##
## **Requisito:** El padre debe ser CharacterBody2D.
@icon("res://icon.svg")
class_name ComponenteCarController
extends Node
const _tool_context = "RuichisLab/Nodos"

@export_group("Motor")
## Velocidad máxima en píxeles/segundo.
@export var velocidad_maxima: float = 500.0
## Qué tan rápido alcanza la velocidad máxima.
@export var aceleracion: float = 400.0
## Potencia de frenado (marcha atrás).
@export var frenado: float = 800.0
## Resistencia natural al rodar (sin acelerar).
@export var friccion: float = 200.0

@export_group("Dirección")
## Velocidad de giro en radianes por segundo.
@export var velocidad_giro: float = 3.0 
## Factor de agarre (0.0 = Hielo, 1.0 = Rieles).
## Valores bajos (0.5 - 0.8) permiten derrapar.
@export var factor_derrape: float = 0.9

var cuerpo: CharacterBody2D
var velocidad_actual: float = 0.0

func _ready():
	cuerpo = get_parent() as CharacterBody2D
	if not cuerpo:
		push_error("NC_CarController debe ser hijo de CharacterBody2D")

func _physics_process(delta):
	if not cuerpo: return
	
	# 1. INPUTS
	var input_acelerar = Input.get_axis("ui_down", "ui_up") # Arriba acelera
	var input_giro = Input.get_axis("ui_left", "ui_right")
	
	# 2. GIRO (Solo si se mueve)
	if abs(velocidad_actual) > 10.0:
		var direccion_giro = 1 if velocidad_actual > 0 else -1
		cuerpo.rotation += input_giro * velocidad_giro * delta * direccion_giro
	
	# 3. ACELERACIÓN
	if input_acelerar != 0:
		velocidad_actual = move_toward(velocidad_actual, input_acelerar * velocidad_maxima, aceleracion * delta)
	else:
		velocidad_actual = move_toward(velocidad_actual, 0, friccion * delta)
		
	# Frenado extra si vamos en contra
	if input_acelerar != 0 and sign(input_acelerar) != sign(velocidad_actual):
		velocidad_actual = move_toward(velocidad_actual, 0, frenado * delta)

	# 4. VECTOR DE MOVIMIENTO (Con Derrape)
	var direccion_frontal = Vector2.RIGHT.rotated(cuerpo.rotation)
	
	# Si factor_derrape es 1, nos movemos exactamente hacia donde miramos.
	# Si es menor, conservamos parte del momentum anterior (derrape).
	var velocidad_deseada = direccion_frontal * velocidad_actual
	
	# Mezclar velocidad anterior con la deseada para simular inercia
	cuerpo.velocity = cuerpo.velocity.lerp(velocidad_deseada, factor_derrape * 5.0 * delta)
	
	cuerpo.move_and_slide()
