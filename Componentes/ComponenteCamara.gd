# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd
## Cámara con efectos juicy (shake, zoom, smooth).
##
## **Uso:** Reemplaza la Camera2D estándar con esta versión mejorada.
## Incluye shake, zoom dinámico y seguimiento suave.
##
## **Casos de uso:**
## - Cámara del jugador
## - Efectos de impacto
## - Zoom en cinemáticas
## - Transiciones suaves
##
## **Requisito:** Debe heredar de Camera2D.
@icon("res://icon.svg")
class_name ComponenteCamara
extends Camera2D
const _tool_context = "RuichisLab/Nodos"

# Cámara "Juicy" para cualquier género.
# Añádela a tu personaje o nivel.

@export var objetivo: Node2D
@export var velocidad_suavizado: float = 5.0
@export var decaimiento_trauma: float = 2.0 # Qué tan rápido para de temblar
@export var max_offset: Vector2 = Vector2(10, 10) # Intensidad máxima del temblor
@export var max_roll: float = 0.1 # Rotación máxima

var trauma: float = 0.0 # 0.0 a 1.0

func _ready():
	if not objetivo:
		# Intentar seguir al padre si es un Node2D
		if get_parent() is Node2D:
			objetivo = get_parent()
			top_level = true # Desacoplarse para suavizado real
			
	# Conectarse al bus de eventos para sacudidas automáticas
	if EventBus:
		EventBus.entidad_danada.connect(_on_entidad_danada)

func _process(delta):
	if objetivo:
		global_position = global_position.lerp(objetivo.global_position, velocidad_suavizado * delta)
		
	if trauma > 0:
		trauma = max(trauma - decaimiento_trauma * delta, 0)
		_aplicar_shake()

func _aplicar_shake():
	var cantidad = trauma * trauma # Función cuadrática para mejor "feel"
	offset.x = max_offset.x * cantidad * randf_range(-1, 1)
	offset.y = max_offset.y * cantidad * randf_range(-1, 1)
	rotation = max_roll * cantidad * randf_range(-1, 1)

func agregar_trauma(cantidad: float):
	trauma = min(trauma + cantidad, 1.0)

func _on_entidad_danada(entidad, cantidad, critico):
	# Si el jugador recibe daño, sacudida fuerte
	if entidad.is_in_group("jugador"):
		agregar_trauma(0.5)
	# Si un enemigo muere o recibe crítico, sacudida pequeña
	elif critico:
		agregar_trauma(0.3)
