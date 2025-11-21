# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHurtbox.gd
## Área responsable de detectar y procesar el daño recibido.
##
## **Uso:** Debe ser hijo de un Area2D. Requiere estar conectado a un recurso o nodo de Estadísticas.
##
## **Requisitos:**
## - Colisión configurada (monitoring/monitorable) en capas de "Hurtbox" del proyecto.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Hurtbox
extends Area2D

# --- CONFIGURACIÓN ---

## Nodo o Recurso de Estadísticas donde se aplicará el daño.
## Si se deja vacío, intentará buscar un nodo llamado "Estadisticas" en el padre.
@export var nodo_estadisticas: Node

## Si es true, el objeto no procesará ningún daño.
@export var invulnerable: bool = false

## Tiempo de invulnerabilidad tras recibir daño (en segundos).
@export var tiempo_invulnerabilidad: float = 0.0

# --- SEÑALES ---
signal dano_recibido(cantidad: float, origen: Node)
signal invulnerabilidad_iniciada
signal invulnerabilidad_terminada

# Estado interno
var _timer_invulnerabilidad: Timer = null

func _ready() -> void:
	# Autoconfiguración opcional si no se define externamente
	# monitorable = true # Para que Hitboxes lo detecten
	
	if not nodo_estadisticas:
		var padre = get_parent()
		if padre and padre.has_node("Estadisticas"):
			nodo_estadisticas = padre.get_node("Estadisticas")

	if tiempo_invulnerabilidad > 0:
		_timer_invulnerabilidad = Timer.new()
		_timer_invulnerabilidad.one_shot = true
		_timer_invulnerabilidad.timeout.connect(_on_invulnerabilidad_terminada)
		add_child(_timer_invulnerabilidad)

## Función pública llamada por las Hitboxes para aplicar daño.
func recibir_dano(cantidad: float, origen: Node = null) -> void:
	if invulnerable: return
	
	# print("%s recibió %f de daño" % [get_parent().name, cantidad])
	
	# Notificar
	emit_signal("dano_recibido", cantidad, origen)
	
	# Evento Global
	if Engine.has_singleton("GameManager"):
		GameManager.emitir_evento("dano_recibido", {"objetivo": get_parent(), "cantidad": cantidad, "origen": origen})

	# Aplicar daño a estadísticas
	if nodo_estadisticas and nodo_estadisticas.has_method("aplicar_dano"):
		nodo_estadisticas.aplicar_dano(cantidad)
	elif nodo_estadisticas and nodo_estadisticas.has_method("take_damage"):
		nodo_estadisticas.take_damage(cantidad)
	else:
		push_warning("RL_Hurtbox en %s recibió daño pero no tiene nodo Estadisticas válido." % get_parent().name)

	# Manejar invulnerabilidad temporal
	if tiempo_invulnerabilidad > 0 and _timer_invulnerabilidad:
		set_invulnerable_temporal(tiempo_invulnerabilidad)

func set_invulnerable_temporal(tiempo: float) -> void:
	invulnerable = true
	emit_signal("invulnerabilidad_iniciada")
	if _timer_invulnerabilidad:
		_timer_invulnerabilidad.start(tiempo)

func _on_invulnerabilidad_terminada() -> void:
	invulnerable = false
	emit_signal("invulnerabilidad_terminada")

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	# Validar colisión
	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo para definir el área vulnerable.")

	return warnings
