# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd
## Generador de instancias en intervalos regulares o manuales.
##
## **Uso:** Ideal para oleadas de enemigos, proyectiles o items.
## Soporta integración con PoolManager (opcional) o instanciación directa.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Spawner
extends Marker2D

# --- CONFIGURACIÓN ---

## Escena a instanciar (si no se usa PoolManager).
@export var escena: PackedScene

## ID del objeto en el PoolManager (si se usa PoolManager).
@export var id_pool: String = ""

## Comenzar automáticamente al cargar.
@export var auto_start: bool = true

## Intervalo base entre spawns (segundos).
@export var intervalo: float = 2.0

## Variación aleatoria (+/- segundos).
@export var aleatoriedad: float = 0.5

## Límite de instancias activas (0 = infinito).
@export var limite_activos: int = 0

## Contenedor donde se añadirán los hijos (si vacío, se añaden al árbol raíz).
@export var contenedor: NodePath

# Estado interno
var _timer: Timer
var _activos: int = 0

func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_on_timeout)
	
	if auto_start:
		iniciar()

## Inicia el ciclo de generación.
func iniciar() -> void:
	_programar_siguiente()

## Detiene la generación.
func detener() -> void:
	_timer.stop()

## Fuerza el spawn inmediato.
func spawnear() -> void:
	if limite_activos > 0 and _activos >= limite_activos:
		return

	var instancia: Node = null

	# 1. Intentar PoolManager
	if id_pool != "" and Engine.has_singleton("PoolManager"):
		var pm = Engine.get_singleton("PoolManager")
		if pm.has_method("spawn"):
			instancia = pm.spawn(id_pool, global_position, global_rotation)

	# 2. Fallback a instanciación directa
	elif escena:
		instancia = escena.instantiate()
		instancia.global_position = global_position
		instancia.global_rotation = global_rotation

		var target_parent = get_tree().current_scene
		if contenedor:
			var c = get_node_or_null(contenedor)
			if c: target_parent = c

		target_parent.add_child(instancia)
	
	# Lógica post-spawn
	if instancia:
		_activos += 1
		# Conectar señal de salida para decrementar contador
		if not instancia.tree_exited.is_connected(_on_instancia_exited):
			instancia.tree_exited.connect(_on_instancia_exited)

func _programar_siguiente() -> void:
	var tiempo = max(0.1, intervalo + randf_range(-aleatoriedad, aleatoriedad))
	_timer.start(tiempo)

func _on_timeout() -> void:
	spawnear()
	_programar_siguiente()

func _on_instancia_exited() -> void:
	if _activos > 0:
		_activos -= 1

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if escena == null and id_pool == "":
		warnings.append("Debes asignar una Escena o un ID de PoolManager.")
	return warnings
