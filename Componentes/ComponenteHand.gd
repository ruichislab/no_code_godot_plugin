# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHand.gd
## Mano de cartas con disposición automática.
##
## **Uso:** Añade este componente para organizar cartas en la mano del jugador.
## Las cartas se distribuyen en arco automáticamente.
##
## **Casos de uso:**
## - Mano del jugador en juegos de cartas
## - Inventario de habilidades
## - Selector de items
##
## **Requisito:** Debe heredar de Control.
@icon("res://icon.svg")
class_name ComponenteHand
extends Control
const _tool_context = "RuichisLab/Nodos"

## Distancia entre cartas.
@export var separacion: float = 50.0
## Grados de rotación por carta.
@export var curvatura: float = 10.0 
## Altura del arco visual.
@export var altura_arco: float = 20.0

func _ready():
	# Conectar señal para cuando se añaden/quitan hijos
	child_entered_tree.connect(_on_child_changed)
	child_exiting_tree.connect(_on_child_changed)
	call_deferred("organizar_cartas")

func _on_child_changed(_node):
	call_deferred("organizar_cartas")

func organizar_cartas():
	var cartas = []
	for child in get_children():
		if child is Control: # Asumimos que son cartas
			cartas.append(child)
			
	var total = cartas.size()
	if total == 0: return
	
	var centro_x = size.x / 2.0
	var inicio_x = centro_x - ((total - 1) * separacion) / 2.0
	
	for i in range(total):
		var carta = cartas[i]
		var destino_x = inicio_x + (i * separacion)
		
		# Calcular arco
		var factor = 0.0
		if total > 1:
			factor = (float(i) / (total - 1)) - 0.5 # -0.5 a 0.5
			
		var destino_y = abs(factor) * altura_arco
		var rotacion = factor * curvatura
		
		# Aplicar posición (idealmente con Tween, pero directo por ahora para simplicidad)
		carta.position = Vector2(destino_x, destino_y)
		carta.rotation_degrees = rotacion
		
		# Guardar posición original en la carta si tiene la propiedad
		if "posicion_original" in carta:
			carta.posicion_original = carta.global_position
