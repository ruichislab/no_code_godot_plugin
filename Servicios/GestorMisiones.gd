# Archivo: Servicios/GestorMisiones.gd
extends Node

# Configurar como Autoload: "GestorMisiones"

signal mision_aceptada(mision: RecursoMision)
signal mision_actualizada(mision: RecursoMision, progreso_actual: int)
signal mision_completada(mision: RecursoMision)

# Estructura: { "id_mision": { "ruta_recurso": "res://...", "progreso": 0 } }
# Guardamos la ruta del recurso para poder recargarlo al iniciar.
var misiones_activas: Dictionary = {} 
var misiones_completadas: Array = [] # Lista de IDs de misiones terminadas

func aceptar_mision(mision: RecursoMision):
	if not mision: return
	if es_mision_completada(mision.id_mision):
		print("Misión ya completada: " + mision.titulo)
		return
	if es_mision_activa(mision.id_mision):
		print("Misión ya activa: " + mision.titulo)
		return

	misiones_activas[mision.id_mision] = {
		"ruta_recurso": mision.resource_path,
		"progreso": 0,
		"recurso_cache": mision # Referencia temporal para acceso rápido
	}
	
	print("Misión aceptada: " + mision.titulo)
	emit_signal("mision_aceptada", mision)

func avanzar_progreso(id_objetivo: String, cantidad: int = 1):
	# Buscamos en todas las misiones activas si alguna tiene este objetivo
	for id_mision in misiones_activas:
		var datos = misiones_activas[id_mision]
		var mision = _obtener_recurso_mision(datos)
		
		if mision and mision.id_objetivo == id_objetivo:
			datos.progreso += cantidad
			print("Progreso misión '%s': %d/%d" % [mision.titulo, datos.progreso, mision.cantidad_necesaria])
			emit_signal("mision_actualizada", mision, datos.progreso)
			
			if datos.progreso >= mision.cantidad_necesaria:
				_completar_mision_interna(id_mision, mision)

func _completar_mision_interna(id_mision: String, mision: RecursoMision):
	misiones_activas.erase(id_mision)
	misiones_completadas.append(id_mision)
	
	print("¡Misión Completada!: " + mision.titulo)
	
	# Entregar Recompensas
	# Entregar Recompensas
	var inv = _get_inventory_manager()
	if mision.oro > 0 and inv:
		# Asumiendo que InventarioGlobal tiene este método o similar
		# inv.anadir_recurso("moneda_oro", mision.oro)
		pass
	
	var gm = _get_game_manager()
	if mision.experiencia > 0:
		if gm and gm.jugador and gm.jugador.has_method("anadir_experiencia"):
			gm.jugador.anadir_experiencia(mision.experiencia)
			
	for item in mision.items_recompensa:
		if item and inv:
			inv.anadir_objeto(item.id_unico, 1)
			
	emit_signal("mision_completada", mision)

# --- UTILIDADES ---

func es_mision_activa(id_mision: String) -> bool:
	return misiones_activas.has(id_mision)

func es_mision_completada(id_mision: String) -> bool:
	return misiones_completadas.has(id_mision)

func _obtener_recurso_mision(datos: Dictionary) -> RecursoMision:
	if datos.has("recurso_cache") and datos.recurso_cache:
		return datos.recurso_cache
	
	# Si cargamos partida, el cache puede ser null, lo recargamos
	if ResourceLoader.exists(datos.ruta_recurso):
		var res = load(datos.ruta_recurso)
		datos["recurso_cache"] = res
		return res
	return null

# --- PERSISTENCIA ---

func guardar_datos() -> Dictionary:
	# Limpiamos el cache antes de guardar para no serializar objetos Resource complejos innecesariamente
	var datos_limpios = misiones_activas.duplicate(true)
	for k in datos_limpios:
		datos_limpios[k].erase("recurso_cache")
		
	return {
		"activas": datos_limpios,
		"completadas": misiones_completadas
	}

func cargar_datos(datos: Dictionary):
	if datos.has("activas"):
		misiones_activas = datos.activas
	if datos.has("completadas"):
		misiones_completadas = datos.completadas

func _get_inventory_manager() -> Node:
	if Engine.has_singleton("InventarioGlobal"): return Engine.get_singleton("InventarioGlobal")
	if is_inside_tree(): return get_tree().root.get_node_or_null("InventarioGlobal")
	return null

func _get_game_manager() -> Node:
	if Engine.has_singleton("GameManager"): return Engine.get_singleton("GameManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GameManager")
	return null
