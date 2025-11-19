# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteGridMovement.gd
## Movimiento basado en grid/cuadrícula.
##
## **Uso:** Añade este componente para movimiento en grids (como Fire Emblem).
## Se mueve de casilla en casilla.
##
## **Casos de uso:**
## - Juegos tácticos
## - Roguelikes
## - Puzzle games
## - Juegos de tablero
##
## **Nota:** Define el tamaño de la celda en píxeles.
@icon("res://icon.svg")
class_name ComponenteGridMovement
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var tamano_celda: Vector2 = Vector2(64, 64)
@export var velocidad: float = 5.0 # Celdas por segundo (animación)
@export var input_activo: bool = true # Si se mueve con flechas

var padre: Node2D
var destino_grid: Vector2
var moviendose: bool = false

func _ready():
	padre = get_parent() as Node2D
	if padre:
		# Alinear a la grilla inicial
		destino_grid = padre.position
		snap_to_grid()

func _process(delta):
	if not padre: return
	
	if moviendose:
		padre.position = padre.position.move_toward(destino_grid, velocidad * tamano_celda.x * delta)
		if padre.position.distance_to(destino_grid) < 1.0:
			padre.position = destino_grid
			moviendose = false
	elif input_activo:
		var dir = Vector2.ZERO
		if Input.is_action_pressed("ui_right"): dir.x += 1
		elif Input.is_action_pressed("ui_left"): dir.x -= 1
		elif Input.is_action_pressed("ui_down"): dir.y += 1
		elif Input.is_action_pressed("ui_up"): dir.y -= 1
		
		if dir != Vector2.ZERO:
			mover_relativo(dir)

func mover_relativo(direccion: Vector2):
	if moviendose: return
	
	var nuevo_destino = padre.position + (direccion * tamano_celda)
	# Aquí se podría chequear colisiones con un RayCast2D antes de mover
	destino_grid = nuevo_destino
	moviendose = true

func snap_to_grid():
	if padre:
		var x = round(padre.position.x / tamano_celda.x) * tamano_celda.x
		var y = round(padre.position.y / tamano_celda.y) * tamano_celda.y
		padre.position = Vector2(x, y)
		destino_grid = padre.position
