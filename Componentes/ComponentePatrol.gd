# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd
## Sistema de patrulla simple (Lineal o por Waypoints).
##
## **Uso:** Añadir como hijo de un CharacterBody2D o Node2D.
## Mueve automáticamente al padre entre puntos definidos.
##
## **Visualización:** En el editor, muestra líneas indicando la ruta (si es lineal).
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Patrol
extends Node2D

# --- CONFIGURACIÓN ---
## Velocidad de movimiento (px/s).
@export var velocidad: float = 100.0

## Tiempo de espera al llegar a un punto (segundos).
@export var esperar_en_extremos: float = 1.0

# --- MODO LINEAL ---
## Distancia a recorrer desde el punto inicial (izquierda/derecha).
@export var distancia_fija: float = 200.0:
	set(value):
		distancia_fija = value
		queue_redraw()

# --- MODO WAYPOINTS ---
## Si es true, usa una lista de nodos Marker2D hijos como ruta.
@export var usar_waypoints: bool = false:
	set(value):
		usar_waypoints = value
		notify_property_list_changed()

# Estado Interno
var padre: Node2D
var punto_inicio: Vector2
var objetivo: Vector2
var indice_waypoint: int = 0
var direccion: int = 1 # 1 o -1 para lineal
var esperando: bool = false
var ruta_waypoints: Array[Node2D] = []

func _ready() -> void:
	# Inicialización en runtime
	if not Engine.is_editor_hint():
		padre = get_parent() as Node2D
		if not padre:
			push_error("RL_Patrol debe ser hijo de un Node2D.")
			return

		punto_inicio = padre.global_position

		if usar_waypoints:
			_recopilar_waypoints()

		_calcular_siguiente_objetivo()

func _process(delta: float) -> void:
	# Modo Editor: Solo redibujar
	if Engine.is_editor_hint():
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

			# Si el padre usa TopDownController o similar para animar, la velocidad ya está seteada.
			# Pero si solo queremos moverlo nosotros:
			# (Nota: move_and_slide usa la velocidad interna, así que está bien)
		else:
			padre.global_position += dir_vector * velocidad * delta
			
		# Girar padre visualmente (flip simple)
		if dir_vector.x != 0:
			# Intentar voltear scale.x manteniendo magnitud
			if padre.scale.x != 0:
				padre.scale.x = abs(padre.scale.x) * sign(dir_vector.x)

func _llegue_al_destino() -> void:
	esperando = true
	if esperar_en_extremos > 0:
		await get_tree().create_timer(esperar_en_extremos).timeout
	
	if not is_instance_valid(this): return # Seguridad por si se borró durante el await

	esperando = false

	if usar_waypoints:
		# Avanzar al siguiente waypoint (circular)
		indice_waypoint = (indice_waypoint + 1) % ruta_waypoints.size()
	else:
		# Invertir dirección lineal
		direccion *= -1

	_calcular_siguiente_objetivo()

func _recopilar_waypoints() -> void:
	ruta_waypoints.clear()
	for child in get_children():
		if child is Marker2D or child is Node2D:
			ruta_waypoints.append(child)

	if ruta_waypoints.size() == 0:
		push_warning("RL_Patrol configurado para Waypoints pero no tiene hijos Node2D/Marker2D.")
		# Fallback a lineal
		usar_waypoints = false

func _calcular_siguiente_objetivo() -> void:
	if usar_waypoints and ruta_waypoints.size() > 0:
		objetivo = ruta_waypoints[indice_waypoint].global_position
	else:
		# Modo lineal simple: Izquierda <-> Derecha desde el inicio
		if direccion == 1:
			objetivo = punto_inicio + Vector2(distancia_fija, 0)
		else:
			objetivo = punto_inicio - Vector2(distancia_fija, 0)

func _draw() -> void:
	if not Engine.is_editor_hint(): return
	
	# Visualización en Editor
	if not usar_waypoints:
		draw_line(Vector2.ZERO, Vector2(distancia_fija, 0), Color.GREEN, 2.0)
		draw_line(Vector2.ZERO, Vector2(-distancia_fija, 0), Color.RED, 2.0)
		draw_circle(Vector2(distancia_fija, 0), 5.0, Color.GREEN)
		draw_circle(Vector2(-distancia_fija, 0), 5.0, Color.RED)
	else:
		# Dibujar líneas conectando hijos
		var hijos = []
		for child in get_children():
			if child is Node2D: hijos.append(child)

		for i in range(hijos.size()):
			var actual = hijos[i].position
			var siguiente = hijos[(i + 1) % hijos.size()].position
			draw_line(actual, siguiente, Color.CYAN, 2.0, true)
			draw_circle(actual, 5.0, Color.CYAN)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is Node2D:
		warnings.append("Este componente debe ser hijo de un Node2D (Sprite, CharacterBody2D, etc) para moverlo.")

	if usar_waypoints:
		var tiene_markers = false
		for child in get_children():
			if child is Marker2D or child is Node2D:
				tiene_markers = true
				break
		if not tiene_markers:
			warnings.append("Modo Waypoints activo: Añade nodos Marker2D como hijos para definir la ruta.")

	return warnings
