# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteAreaEffect.gd
## Área con efecto de estado.
##
## **Uso:** Añade este componente para crear zonas que aplican efectos.
## Aplica buffs/debuffs mientras el jugador está dentro.
##
## **Casos de uso:**
## - Zonas de curación
## - Zonas de veneno
## - Campos de velocidad
## - Auras de buff
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteAreaEffect
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var multiplicador_velocidad: float = 1.0 # <1 Lento, >1 Rápido
@export var multiplicador_salto: float = 1.0
@export var gravedad_extra: float = 0.0

# Diccionario para guardar valores originales: { body_id: { "speed": 100, "jump": 300 } }
var originales: Dictionary = {}

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Intentar detectar controlador
	var controller = _buscar_controller(body)
	if controller:
		_guardar_originales(body.get_instance_id(), controller)
		_aplicar_efecto(controller)

func _on_body_exited(body):
	var controller = _buscar_controller(body)
	if controller:
		_restaurar_originales(body.get_instance_id(), controller)

func _buscar_controller(body) -> Node:
	# Buscar componentes hijos conocidos
	for child in body.get_children():
		if child is ComponentePlatformerController or child is ComponenteTopDownController:
			return child
	return null

func _guardar_originales(id, controller):
	if not originales.has(id):
		var datos = {}
		if "velocidad_movimiento" in controller:
			datos["velocidad_movimiento"] = controller.velocidad_movimiento
		if "fuerza_salto" in controller:
			datos["fuerza_salto"] = controller.fuerza_salto
		originales[id] = datos

func _aplicar_efecto(controller):
	if "velocidad_movimiento" in controller:
		controller.velocidad_movimiento *= multiplicador_velocidad
	if "fuerza_salto" in controller:
		controller.fuerza_salto *= multiplicador_salto

func _restaurar_originales(id, controller):
	if originales.has(id):
		var datos = originales[id]
		if "velocidad_movimiento" in controller:
			controller.velocidad_movimiento = datos["velocidad_movimiento"]
		if "fuerza_salto" in controller:
			controller.fuerza_salto = datos["fuerza_salto"]
		originales.erase(id)
