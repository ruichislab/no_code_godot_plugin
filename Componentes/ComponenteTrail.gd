# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTrail.gd
## Efecto de estela de movimiento.
##
## **Uso:** Añade este componente para crear un rastro visual detrás del objeto.
## Ideal para movimientos rápidos.
##
## **Casos de uso:**
## - Dash del jugador
## - Proyectiles rápidos
## - Espadas en movimiento
## - Efectos de velocidad
##
## **Requisito:** Debe ser hijo de un Line2D.
@icon("res://icon.svg")
class_name ComponenteTrail
extends Line2D
const _tool_context = "RuichisLab/Nodos"

@export var longitud: int = 10
@export var ancho_inicial: float = 10.0
@export var ancho_final: float = 0.0
@export var color_inicial: Color = Color.WHITE
@export var color_final: Color = Color(1, 1, 1, 0)

var puntos: Array[Vector2] = []
var padre: Node2D

func _ready():
	top_level = true # Desacoplar del padre para que la estela no rote con él rígidamente
	padre = get_parent() as Node2D
	
	width = ancho_inicial
	default_color = color_inicial
	gradient = Gradient.new()
	gradient.set_color(0, color_inicial)
	gradient.set_color(1, color_final)
	
	# Curva de ancho
	width_curve = Curve.new()
	width_curve.add_point(Vector2(0, 1))
	width_curve.add_point(Vector2(1, 0))

func _process(delta):
	if not padre:
		# Si el padre muere, desvanecer y borrar
		if points.size() > 0:
			remove_point(0)
		else:
			queue_free()
		return
		
	global_position = Vector2.ZERO
	global_rotation = 0
	
	puntos.append(padre.global_position)
	
	if puntos.size() > longitud:
		puntos.pop_front()
		
	points = PackedVector2Array(puntos)
