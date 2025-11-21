# Archivo: addons/no_code_godot_plugin/Servicios/GestorMisiones.gd
## Sistema de gestión de Misiones (Quests) con persistencia y eventos.
##
## **Uso:** Autoload 'GestorMisiones'.
## **Características:** Soporta misiones activas, completadas, seguimiento de progreso y recompensas.
extends Node

# --- SEÑALES ---
signal mision_aceptada(mision: RL_RecursoMision)
signal mision_actualizada(mision: RL_RecursoMision, progreso: int)
signal mision_completada(mision: RL_RecursoMision)

# --- ESTADO ---
# Estructura: { "id_mision": { "ruta": "res://...", "progreso": 0 } }
var misiones_activas: Dictionary = {}
var misiones_completadas: Array = []

func _ready() -> void:
	# Escuchar eventos globales para avanzar misiones automáticamente
	if Engine.has_singleton("EventBus"):
		var bus = Engine.get_singleton("EventBus")
		if bus.has_signal("evento_global"):
			bus.evento_global.connect(_on_evento_global)

## Acepta una nueva misión.
func aceptar_mision(mision: RL_RecursoMision) -> void:
	if not mision: return

	if es_mision_completada(mision.id_mision):
		# print("Misión ya completada: %s" % mision.titulo)
		return

	if es_mision_activa(mision.id_mision):
		# print("Misión ya activa: %s" % mision.titulo)
		return

	misiones_activas[mision.id_mision] = {
		"ruta": mision.resource_path,
		"progreso": 0
	}
	
	emit_signal("mision_aceptada", mision)
	# print("Misión aceptada: %s" % mision.titulo)

	# Mostrar notificación
	if Engine.has_singleton("FloatingTextManager"):
		Engine.get_singleton("FloatingTextManager").call("mostrar_notificacion", "Misión: " + mision.titulo)

## Avanza el progreso de un objetivo específico.
func avanzar_progreso(id_objetivo: String, cantidad: int = 1) -> void:
	# Iterar sobre copias de las claves para seguridad
	var keys = misiones_activas.keys()

	for id in keys:
		var estado = misiones_activas[id]
		var mision = _cargar_recurso(estado.ruta)
		
		if mision and mision.id_objetivo == id_objetivo:
			estado.progreso += cantidad
			emit_signal("mision_actualizada", mision, estado.progreso)
			
			if estado.progreso >= mision.cantidad_necesaria:
				_completar_mision(id, mision)

func _completar_mision(id: String, mision: RL_RecursoMision) -> void:
	misiones_activas.erase(id)
	misiones_completadas.append(id)
	
	emit_signal("mision_completada", mision)
	
	# Entregar Recompensas
	if Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")

		# Items
		for item in mision.items_recompensa:
			if inv.has_method("agregar_item"):
				inv.agregar_item(item, 1)

		# Oro (si existe método)
		if mision.oro > 0 and inv.has_method("agregar_oro"):
			inv.agregar_oro(mision.oro)
			
	if Engine.has_singleton("FloatingTextManager"):
		Engine.get_singleton("FloatingTextManager").call("mostrar_notificacion", "¡Misión Completada!", Color.GREEN)

# --- CONSULTAS ---

func es_mision_activa(id: String) -> bool:
	return misiones_activas.has(id)

func es_mision_completada(id: String) -> bool:
	return id in misiones_completadas

func obtener_mision_activa(id: String) -> RL_RecursoMision:
	if misiones_activas.has(id):
		return _cargar_recurso(misiones_activas[id].ruta)
	return null

# --- PERSISTENCIA ---

func guardar_datos() -> Dictionary:
	return {
		"activas": misiones_activas,
		"completadas": misiones_completadas
	}

func cargar_datos(datos: Dictionary) -> void:
	if datos.has("activas"):
		misiones_activas = datos.activas
	if datos.has("completadas"):
		misiones_completadas = datos.completadas

# --- INTERNO ---

func _cargar_recurso(path: String) -> RL_RecursoMision:
	if ResourceLoader.exists(path):
		return load(path) as RL_RecursoMision
	return null

func _on_evento_global(nombre: String, datos: Dictionary) -> void:
	# Soporte para eventos genéricos como "enemigo_muerto"
	if nombre == "enemigo_muerto":
		var id_enemigo = datos.get("id", "")
		if id_enemigo != "":
			avanzar_progreso("matar_" + id_enemigo)
	elif nombre == "item_recogido":
		var id_item = datos.get("id", "")
		if id_item != "":
			avanzar_progreso("recoger_" + id_item)
