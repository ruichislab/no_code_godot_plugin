# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd
## Generador de instancias (Spawners) con visualización de radio.
##
## **Uso:** Oleadas, enemigos, items.
## **Visualización:** Dibuja un círculo amarillo o el sprite de la escena.
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Spawner
extends Marker2D

# --- CONFIGURACIÓN ---
@export var escena: PackedScene:
	set(val):
		escena = val
		queue_redraw()

@export var id_pool: String = ""
@export var auto_start: bool = true
@export var intervalo: float = 2.0
@export var aleatoriedad: float = 0.5
@export var limite_activos: int = 0
@export var contenedor: NodePath

@export_group("Visualización")
@export var radio_spawn: float = 0.0: # 0 = puntual
	set(val):
		radio_spawn = val
		queue_redraw()

# --- ESTADO ---
var _timer: Timer
var _activos: int = 0

func _ready() -> void:
	if not Engine.is_editor_hint():
		_timer = Timer.new()
		_timer.one_shot = true
		add_child(_timer)
		_timer.timeout.connect(_on_timeout)

		if auto_start:
			iniciar()

func iniciar() -> void:
	_programar_siguiente()

func detener() -> void:
	if _timer: _timer.stop()

func spawnear() -> void:
	if limite_activos > 0 and _activos >= limite_activos: return

	# Calcular posición aleatoria si hay radio
	var offset = Vector2.ZERO
	if radio_spawn > 0:
		var angulo = randf() * TAU
		var dist = sqrt(randf()) * radio_spawn
		offset = Vector2(cos(angulo), sin(angulo)) * dist

	var pos_final = global_position + offset

	var instancia: Node = null

	# Pool vs Instancia
	if id_pool != "" and Engine.has_singleton("PoolManager"):
		var pm = Engine.get_singleton("PoolManager")
		if pm.has_method("instanciar"):
			instancia = pm.instanciar(id_pool, pos_final, global_rotation)
	elif escena:
		instancia = escena.instantiate()
		if instancia is Node2D:
			instancia.global_position = pos_final
			instancia.global_rotation = global_rotation

		var target = get_tree().current_scene
		if contenedor:
			var c = get_node_or_null(contenedor)
			if c: target = c
		target.add_child(instancia)
	
	if instancia:
		_activos += 1
		if not instancia.tree_exited.is_connected(_on_instancia_exited):
			instancia.tree_exited.connect(_on_instancia_exited)

func _programar_siguiente() -> void:
	var tiempo = max(0.1, intervalo + randf_range(-aleatoriedad, aleatoriedad))
	if _timer: _timer.start(tiempo)

func _on_timeout() -> void:
	spawnear()
	_programar_siguiente()

func _on_instancia_exited() -> void:
	if _activos > 0: _activos -= 1

# --- DEBUG VISUAL ---
func _draw() -> void:
	if not Engine.is_editor_hint(): return

	var color = Color.YELLOW

	# Icono central
	draw_circle(Vector2.ZERO, 8.0, color)
	draw_line(Vector2(-5, 0), Vector2(5, 0), Color.BLACK, 2.0)
	draw_line(Vector2(0, -5), Vector2(0, 5), Color.BLACK, 2.0)

	# Área
	if radio_spawn > 0:
		draw_arc(Vector2.ZERO, radio_spawn, 0, TAU, 32, color, 1.0)
		var col_trans = color
		col_trans.a = 0.1
		draw_circle(Vector2.ZERO, radio_spawn, col_trans)

	# Preview Sprite (si hay escena asignada)
	if escena:
		var estado = escena.get_state()
		# Intentar encontrar propiedad "texture" en el nodo raíz o primer hijo
		# Esto es complejo sin instanciar (lo cual es lento).
		# Mejor dibujamos el nombre.
		draw_string(ThemeDB.get_fallback_font(), Vector2(-20, -15), "Spawn: " + escena.resource_path.get_file(), HORIZONTAL_ALIGNMENT_CENTER, -1, 12, Color.WHITE)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not escena and id_pool == "": warnings.append("Falta Escena o ID Pool.")
	return warnings
