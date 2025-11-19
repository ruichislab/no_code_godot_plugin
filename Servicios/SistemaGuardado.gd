# Archivo: Servicios/SistemaGuardado.gd
extends Node

# Helpers JSON compatibles con varias versiones de Godot
func _json_stringify(obj) -> String:
	var j = JSON.new()
	if j.has_method("stringify"):
		return j.stringify(obj)
	if j.has_method("print"):
		return j.print(obj)
	return str(obj)

func _json_parse(text):
	var j = JSON.new()
	if j.has_method("parse"):
		var res = j.parse(text)
		return res
	if j.has_method("parse_string"):
		return j.parse_string(text)
	return null

# Helpers de tiempo compatibles
func _now_unix() -> int:
	if typeof(OS) != TYPE_NIL:
		if OS.has_method("get_unix_time"):
			return int(OS.call("get_unix_time"))
		if OS.has_method("get_unix_time_from_system"):
			return int(OS.call("get_unix_time_from_system"))
	# Fallback: 0 si no disponible
	return 0

func _now_ticks_msec() -> int:
	if typeof(OS) != TYPE_NIL:
		if OS.has_method("get_ticks_msec"):
			return int(OS.call("get_ticks_msec"))
		if OS.has_method("get_ticks_usec"):
			return int(OS.call("get_ticks_usec") / 1000)
	return 0

# --- CONFIGURACIÓN ---
# --- CONFIGURACIÓN ---
const PREFIJO_ARCHIVO: String = "user://savegame_"
const EXTENSION: String = ".save"

# --- FUNCIONES PRINCIPALES ---

func obtener_ruta(slot: int) -> String:
	return PREFIJO_ARCHIVO + str(slot) + EXTENSION

func guardar_juego(slot: int = 1):
	print("Iniciando guardado de juego en Slot %d..." % slot)
	
	var datos_guardado: Dictionary = {
		"version": "1.0",
		# Guardar timestamp unix (más portable)
		"fecha": _now_unix(),
		"tiempo_juego": _now_ticks_msec() / 1000.0, # Simple, idealmente usar un TimeManager acumulativo
		"datos_jugador": {},
		"datos_inventario": {}
	}
	
	# 1. Recopilar datos del Jugador (Estadísticas)
	if GameManager.jugador:
		var estadisticas = GameManager.jugador.get_node_or_null("Estadisticas")
		if estadisticas:
			datos_guardado["datos_jugador"] = estadisticas.guardar_datos()
			
		# Guardar posición (opcional, pero útil)
		datos_guardado["posicion_jugador"] = {
			"x": GameManager.jugador.global_position.x,
			"y": GameManager.jugador.global_position.y
		}
			
	# 2. Recopilar datos del Inventario
	datos_guardado["datos_inventario"] = InventarioGlobal.guardar_datos()
	
	# 3. Recopilar datos de Misiones
	if get_tree().root.has_node("GestorMisiones"):
		datos_guardado["datos_misiones"] = get_node("/root/GestorMisiones").guardar_datos()
	
	# 4. Escribir en disco
	var ruta = obtener_ruta(slot)
	var archivo = FileAccess.open(ruta, FileAccess.WRITE)
	if archivo:
		var json_string = _json_stringify(datos_guardado)
		archivo.store_string(json_string)
		archivo.close()
		print("Juego guardado exitosamente en: " + ruta)
	else:
		push_error("Error al intentar guardar el archivo.")

func cargar_juego(slot: int = 1) -> bool:
	var ruta = obtener_ruta(slot)
	if not FileAccess.file_exists(ruta):
		print("No existe archivo de guardado en Slot %d." % slot)
		return false
		
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if not archivo:
		push_error("Error al leer archivo de guardado.")
		return false
		
	var json_string = archivo.get_as_text()
	archivo.close()
	
	var datos_guardado = _json_parse(json_string)
	if typeof(datos_guardado) == TYPE_DICTIONARY or datos_guardado is Dictionary:
		_aplicar_datos_cargados(datos_guardado)
		return true
	else:
		push_error("JSON Parse Error: datos inválidos o malformados")
		return false

func _aplicar_datos_cargados(datos: Dictionary):
	print("Aplicando datos cargados...")
	
	# 1. Cargar Inventario
	if datos.has("datos_inventario"):
		InventarioGlobal.cargar_datos(datos.datos_inventario)
		
	# 2. Cargar Misiones
	if datos.has("datos_misiones") and get_tree().root.has_node("GestorMisiones"):
		get_node("/root/GestorMisiones").cargar_datos(datos.datos_misiones)
		
	# 3. Cargar Jugador
	if GameManager.jugador:
		# Posición
		if datos.has("posicion_jugador"):
			var pos = datos.posicion_jugador
			GameManager.jugador.global_position = Vector2(pos.x, pos.y)
			
		# Estadísticas
		if datos.has("datos_jugador"):
			var estadisticas = GameManager.jugador.get_node_or_null("Estadisticas")
			if estadisticas:
				estadisticas.cargar_datos(datos.datos_jugador)
	
	print("Carga completada.")

func existe_partida(slot: int = 1) -> bool:
	return FileAccess.file_exists(obtener_ruta(slot))

func borrar_partida(slot: int = 1):
	var ruta = obtener_ruta(slot)
	if FileAccess.file_exists(ruta):
		var removed = ERR_UNAVAILABLE
		var rel = ruta
		if ruta.begins_with("user://"):
			rel = ruta.replace("user://", "")
			var dir = DirAccess.open("user://")
			if dir:
				if dir.has_method("remove_file"):
					removed = dir.remove_file(rel)
				elif dir.has_method("remove"):
					removed = dir.remove(rel)

		if removed != OK:
			var f = FileAccess.open(ruta, FileAccess.WRITE)
			if f:
				f.store_string("")
				f.close()
				removed = OK

		if removed == OK:
			print("Partida borrada: Slot %d" % slot)
		else:
			push_error("No se pudo borrar la partida: %s" % ruta)

func obtener_metadata(slot: int) -> Dictionary:
	if not existe_partida(slot):
		return {}
	
	var archivo = FileAccess.open(obtener_ruta(slot), FileAccess.READ)
	if not archivo:
		return {}

	var texto = archivo.get_as_text()
	archivo.close()
	var datos = _json_parse(texto)
	if datos is Dictionary:
		return {
			"fecha": datos.get("fecha", "???"),
			"version": datos.get("version", "1.0")
		}
	return {}
