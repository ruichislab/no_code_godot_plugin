# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd
## Sistema de patrulla (Lineal o Waypoints) con previsualización en editor.
##
## **Uso:** Hijo de un Node2D/CharacterBody2D.
## **Visualización:** Muestra la ruta en verde/cian en el editor.
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Patrol
extends Node2D

# --- CONFIGURACIÓN ---
## Velocidad de movimiento (px/s).
@export var velocidad: float = 100.0

## Tiempo de espera en extremos (segundos).
@export var tiempo_espera: float = 1.0

# --- MODO LINEAL ---
## Distancia a recorrer desde el punto inicial.
@export var distancia_lineal: float = 200.0:
	set(val):
		distancia_lineal = val
		queue_redraw() # Actualizar dibujo

# --- MODO WAYPOINTS ---
## Si es true, usa hijos Marker2D como ruta.
@export var usar_waypoints: bool = false:
	set(val):
		usar_waypoints = val
		notify_property_list_changed()
		queue_redraw()

# --- ESTADO ---
var padre: Node2D
var punto_inicio: Vector2
var objetivo_actual: Vector2
var idx_waypoint: int = 0
var direccion: int = 1
var esperando: bool = false
var lista_waypoints: Array[Node2D] = []

func _ready() -> void:
	if not Engine.is_editor_hint():
		padre = get_parent() as Node2D
		if not padre:
			set_process(false)
			return

		punto_inicio = padre.global_position
		if usar_waypoints:
			_recopilar_waypoints()

		_calcular_siguiente()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		# En editor solo redibujamos si cambian los hijos para actualizar líneas de waypoints
		if usar_waypoints: queue_redraw()
		return

	if esperando or not padre: return
	
	var dist = padre.global_position.distance_to(objetivo_actual)
	
	if dist < 5.0:
		_llegar()
	else:
		var dir = (objetivo_actual - padre.global_position).normalized()
		
		if padre is CharacterBody2D:
			padre.velocity = dir * velocidad
			padre.move_and_slide()
		else:
			padre.global_position += dir * velocidad * delta
			
		# Flip simple
		if dir.x != 0 and padre.scale.x != 0:
			padre.scale.x = abs(padre.scale.x) * sign(dir.x)

func _llegar() -> void:
	esperando = true
	await get_tree().create_timer(tiempo_espera).timeout
	if not is_instance_valid(this): return
	
	esperando = false
	if usar_waypoints:
		idx_waypoint = (idx_waypoint + 1) % lista_waypoints.size()
	else:
		direccion *= -1

	_calcular_siguiente()

func _recopilar_waypoints() -> void:
	lista_waypoints.clear()
	for c in get_children():
		if c is Node2D: lista_waypoints.append(c)

	if lista_waypoints.is_empty():
		usar_waypoints = false # Fallback

func _calcular_siguiente() -> void:
	if usar_waypoints and not lista_waypoints.is_empty():
		objetivo_actual = lista_waypoints[idx_waypoint].global_position
	else:
		if direccion == 1:
			objetivo_actual = punto_inicio + Vector2(distancia_lineal, 0)
		else:
			objetivo_actual = punto_inicio - Vector2(distancia_lineal, 0)

# --- DIBUJADO EN EDITOR ---
func _draw() -> void:
	if not Engine.is_editor_hint(): return
	
	if usar_waypoints:
		var hijos = []
		for c in get_children():
			if c is Node2D: hijos.append(c)

		if hijos.size() > 0:
			# Dibujar conexión con el padre (punto 0)
			draw_line(Vector2.ZERO, hijos[0].position, Color.CYAN, 1.0, true)

			for i in range(hijos.size()):
				var p1 = hijos[i].position
				var p2 = hijos[(i + 1) % hijos.size()].position
				draw_line(p1, p2, Color.CYAN, 2.0, true)
				draw_circle(p1, 8.0, Color.CYAN)
				# Dibujar número
				draw_string(ThemeDB.get_fallback_font(), p1 + Vector2(-5, 5), str(i+1), HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.BLACK)
	else:
		# Lineal: desde 0 a +dist y -dist
		var p_der = Vector2(distancia_lineal, 0)
		var p_izq = Vector2(-distancia_lineal, 0)

		draw_line(Vector2.ZERO, p_der, Color.GREEN, 2.0)
		draw_line(Vector2.ZERO, p_izq, Color.RED, 2.0)
		draw_circle(p_der, 5.0, Color.GREEN)
		draw_circle(p_izq, 5.0, Color.RED)

		# Flechas de dirección
		_dibujar_flecha(Vector2(distancia_lineal/2, 0), Vector2.RIGHT, Color.GREEN)
		_dibujar_flecha(Vector2(-distancia_lineal/2, 0), Vector2.LEFT, Color.RED)

func _dibujar_flecha(pos: Vector2, dir: Vector2, col: Color) -> void:
	var tam = 10.0
	var a = pos + dir * tam
	var b = pos + dir.rotated(2.5) * tam
	var c = pos + dir.rotated(-2.5) * tam
	draw_line(pos - dir * tam, pos + dir * tam, col, 2.0)
	draw_polygon([a, b, c], [col])

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is Node2D:
		warnings.append("El padre debe ser Node2D.")
	if usar_waypoints:
		var count = 0
		for c in get_children():
			if c is Node2D: count += 1
		if count == 0:
			warnings.append("Añade hijos Node2D/Marker2D para los waypoints.")
	return warnings
