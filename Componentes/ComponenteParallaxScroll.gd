# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteParallaxScroll.gd
## Scroll parallax automático.
##
## **Uso:** Añade este componente para crear fondos con efecto parallax.
## Se mueve automáticamente a diferentes velocidades.
##
## **Casos de uso:**
## - Fondos de niveles
## - Nubes en movimiento
## - Estrellas
## - Capas de profundidad
##
## **Nota:** Define la velocidad relativa para cada capa.
@icon("res://icon.svg")
class_name ComponenteParallaxScroll
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var velocidad: Vector2 = Vector2(-10, 0)

var padre: ParallaxLayer

func _ready():
	padre = get_parent() as ParallaxLayer
	if not padre:
		push_warning("NC_ParallaxScroll debe ser hijo de un ParallaxLayer.")

func _process(delta):
	if padre:
		padre.motion_offset += velocidad * delta
