# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteLightFlicker.gd
## Parpadeo de luz (efecto horror).
##
## **Uso:** Añade este componente a luces para crear parpadeo aleatorio.
## Ideal para ambientes de terror.
##
## **Casos de uso:**
## - Luces defectuosas
## - Velas parpadeantes
## - Efectos de horror
## - Luces de emergencia
##
## **Requisito:** El padre debe tener un PointLight2D.
@icon("res://icon.svg")
class_name ComponenteLightFlicker
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var energia_min: float = 0.8
@export var energia_max: float = 1.2
@export var velocidad: float = 10.0
@export var suavizado: float = 0.1

var luz: Light2D
var objetivo: float
var tiempo: float = 0.0

func _ready():
	luz = get_parent() as Light2D
	if not luz:
		push_warning("NC_LightFlicker debe ser hijo de un Light2D.")
		set_process(false)
		return
		
	objetivo = luz.energy

func _process(delta):
	tiempo += delta * velocidad
	
	# Ruido simple usando seno y random
	if randf() < 0.1:
		objetivo = randf_range(energia_min, energia_max)
		
	luz.energy = lerp(luz.energy, objetivo, suavizado)
