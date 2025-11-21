# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHealthBar.gd
## Barra de progreso que refleja automáticamente la salud de un nodo Estadísticas.
##
## **Uso:** Puede ser hija de un personaje (barra flotante) o parte de la UI.
## Requiere conexión a un nodo con señales `salud_cambiada` (como `Estadisticas`).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_HealthBar
extends ProgressBar

# --- CONFIGURACIÓN ---

## Nodo de Estadísticas a monitorear. Si vacío, busca "Estadisticas" en el padre o abuelo (si es UI).
@export var nodo_estadisticas: Node

## Si es true, la barra se oculta automáticamente cuando la salud está al 100%.
@export var ocultar_si_llena: bool = false

## Si es true, la barra baja suavemente en lugar de instantáneamente.
@export var suavizado: bool = true

## Velocidad de interpolación para el suavizado.
@export var velocidad_suavizado: float = 5.0

# Estado
var valor_objetivo: float = 0.0

func _ready() -> void:
	# Búsqueda automática de Estadisticas
	if not nodo_estadisticas:
		# 1. Buscar en padre directo (barra flotante sobre enemigo)
		if get_parent() and get_parent().has_node("Estadisticas"):
			nodo_estadisticas = get_parent().get_node("Estadisticas")
		# 2. Buscar en GameManager (barra de UI del jugador)
		elif Engine.has_singleton("GameManager"):
			var gm = Engine.get_singleton("GameManager")
			if gm.get("jugador") and is_instance_valid(gm.jugador):
				var stats = gm.jugador.get_node_or_null("Estadisticas")
				if stats:
					nodo_estadisticas = stats

	if nodo_estadisticas:
		_conectar_estadisticas()
	else:
		# Intentar conectar más tarde si el jugador aparece después
		if Engine.has_singleton("GameManager"):
			Engine.get_singleton("GameManager").connect("escena_cambiada", _reintentar_conexion)

func _reintentar_conexion(_scena) -> void:
	if not nodo_estadisticas:
		_ready()

func _conectar_estadisticas() -> void:
	if not is_instance_valid(nodo_estadisticas): return

	if nodo_estadisticas.has_signal("salud_cambiada"):
		if not nodo_estadisticas.salud_cambiada.is_connected(_on_salud_cambiada):
			nodo_estadisticas.salud_cambiada.connect(_on_salud_cambiada)

	# Inicializar
	var salud = nodo_estadisticas.get("salud_actual") if "salud_actual" in nodo_estadisticas else 100.0
	var maxima = nodo_estadisticas.get("salud_maxima") if "salud_maxima" in nodo_estadisticas else 100.0

	max_value = maxima
	valor_objetivo = salud
	value = valor_objetivo

	_actualizar_visibilidad()

func _process(delta: float) -> void:
	if suavizado and value != valor_objetivo:
		value = move_toward(value, valor_objetivo, max_value * velocidad_suavizado * delta)

func _on_salud_cambiada(nuevo_valor: float, maximo: float) -> void:
	valor_objetivo = nuevo_valor
	max_value = maximo
	
	if not suavizado:
		value = valor_objetivo
		
	_actualizar_visibilidad()

func _actualizar_visibilidad() -> void:
	if ocultar_si_llena:
		visible = valor_objetivo < max_value
	else:
		visible = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not nodo_estadisticas and not Engine.is_editor_hint():
		# Solo warning si no es autodetectable fácilmente
		# warnings.append("No se ha asignado nodo Estadísticas (intentará autodetectar en runtime).")
		pass
	return warnings
