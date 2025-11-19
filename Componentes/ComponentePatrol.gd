# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd
## Patrullaje automático entre puntos.
##
## **Uso:** Añade este componente a enemigos para que patrullen entre waypoints.
## Se mueve automáticamente entre los puntos definidos.
##
## **Casos de uso:**
## - Guardias patrullando
## - Enemigos en rutas fijas
## - Plataformas móviles
## - NPCs con rutinas
##
## **Nota:** Define los waypoints como nodos Marker2D hijos.
@icon("res://icon.svg")
@tool
class_name ComponentePatrol
extends Node2D
const _tool_context = "RuichisLab/Nodos"

@export var velocidad: float = 100.0
@export var esperar_en_extremos: float = 1.0
@export var distancia_fija: float = 200.0:
	set(value):
		distancia_fija = value
		queue_redraw()
@export var usar_waypoints: bool = false:
	set(value):
		usar_waypoints = value
		notify_property_list_changed()
		queue_redraw()
@export var waypoints: Array[NodePath]

var padre: Node2D
var punto_inicio: Vector2
var objetivo: Vector2
var direccion: int = 1
var esperando: bool = false

func _ready():
	# Si somos Node2D, el padre es nuestro parent directo.
	# Pero la lógica original movía al padre.
	# Al ser Node2D, podemos visualizarnos a nosotros mismos, pero ¿movemos al padre?
	# Sí, mantenemos la lógica de mover al padre.
	padre = get_parent() as Node2D
	if not padre: return
	
	punto_inicio = padre.global_position
	_calcular_siguiente_objetivo()

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()
		return

	if esperando or not padre: return
	
	var distancia = padre.global_position.distance_to(objetivo)
	
	if distancia < 5.0:
		_llegue_al_destino()
	else:
		var dir_vector = (objetivo - padre.global_position).normalized()
		
		# Mover según el tipo de padre
		if padre is CharacterBody2D:
			padre.velocity = dir_vector * velocidad
			padre.move_and_slide()
		else:
			padre.global_position += dir_vector * velocidad * delta
			
		# Girar sprite
		if dir_vector.x != 0:
			padre.scale.x = abs(padre.scale.x) * sign(dir_vector.x)

func _llegue_al_destino():
	esperando = true
	if esperar_en_extremos > 0:
		await get_tree().create_timer(esperar_en_extremos).timeout
	
	esperando = false
	direccion *= -1
	_calcular_siguiente_objetivo()

func _calcular_siguiente_objetivo():
	if usar_waypoints:
		pass
	else:
		if direccion == 1:
			objetivo = punto_inicio + Vector2(distancia_fija, 0)
		else:
			objetivo = punto_inicio - Vector2(distancia_fija, 0)

func _draw():
	if not Engine.is_editor_hint(): return
	
	# Dibujar línea de patrulla simple relativa a la posición inicial (que asumimos es la del padre al inicio)
	if not usar_waypoints:
		# Dibujamos una línea desde -distancia hasta +distancia?
		# La lógica dice: punto_inicio +/- distancia_fija.
		# Visualmente queremos ver el recorrido.
		# Como somos hijos del objeto que se mueve, nuestra posición local 0,0 es el centro del objeto.
		# Pero el objeto se mueve, así que el dibujo se movería con él.
		# Para visualizar la RUTA estática, deberíamos ser hermanos o no movernos.
		# Pero este componente MUEVE al padre.
		# Visualización simple: Línea hacia la derecha e izquierda indicando el rango.
		
		draw_line(Vector2.ZERO, Vector2(distancia_fija, 0), Color.GREEN, 2.0)
		draw_line(Vector2.ZERO, Vector2(-distancia_fija, 0), Color.RED, 2.0)
		draw_circle(Vector2(distancia_fija, 0), 5.0, Color.GREEN)
		draw_circle(Vector2(-distancia_fija, 0), 5.0, Color.RED)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not get_parent() is Node2D:
		warnings.append("Este componente debe ser hijo de un Node2D (Sprite, CharacterBody2D, etc) para moverlo.")
	return warnings
