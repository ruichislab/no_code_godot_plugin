# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd
## Generador de objetos con pooling.
##
## **Uso:** Añade este componente para generar enemigos, items o proyectiles.
## Usa object pooling para máximo rendimiento.
##
## **Casos de uso:**
## - Spawn de enemigos
## - Generadores de items
## - Emisores de partículas
## - Oleadas de enemigos
##
## **Requisito:** Debe ser hijo de un Marker2D. Requiere PoolManager activo.
@icon("res://icon.svg")
class_name ComponenteSpawner
extends Marker2D
const _tool_context = "RuichisLab/Nodos"

## ID del objeto en el PoolManager (ej: "enemigo_basico").
@export var id_pool: String = "enemigo_basico"
## Comenzar a spawnear automáticamente al inicio.
@export var auto_start: bool = false
## Tiempo base entre spawns (segundos).
@export var intervalo: float = 2.0
## Variación aleatoria del tiempo (+/- segundos).
@export var aleatoriedad: float = 0.5 
## Cantidad máxima de objetos vivos simultáneos (0 = infinito).
@export var limite_activos: int = 5

var timer: Timer
var activos: int = 0

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timeout)
	
	if auto_start:
		iniciar()

## Inicia el ciclo de generación.
func iniciar():
	_reiniciar_timer()

## Detiene la generación.
func detener():
	timer.stop()

## Fuerza la generación de un objeto ahora mismo.
func spawnear():
	if activos >= limite_activos and limite_activos > 0: return
	
	if PoolManager:
		var obj = PoolManager.spawn(id_pool, global_position, rotation)
		if obj:
			activos += 1
			# Detectar cuando muere/desaparece para restar contador
			if obj.has_signal("tree_exited"): # O una señal propia 'despawned'
				obj.tree_exited.connect(func(): activos -= 1)

func _on_timeout():
	spawnear()
	_reiniciar_timer()

	var tiempo = intervalo + randf_range(-aleatoriedad, aleatoriedad)
	timer.start(max(0.1, tiempo))

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not get_parent() is Marker2D:
		warnings.append("Este componente debe ser hijo de un Marker2D para definir la posición de spawn.")
	if not Engine.has_singleton("PoolManager") and not ProjectSettings.has_setting("autoload/PoolManager"):
		# Nota: Esta comprobación es aproximada, ya que los autoloads se cargan en runtime.
		# Una comprobación más robusta sería verificar si existe el nodo en el árbol si estuviéramos en runtime.
		# Para el editor, solo podemos sugerir.
		warnings.append("Se recomienda tener un Autoload llamado 'PoolManager' para que el pooling funcione correctamente.")
	return warnings
