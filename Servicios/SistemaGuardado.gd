# Archivo: Servicios/SistemaGuardado.gd
extends Node

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
		"fecha": Time.get_datetime_string_from_system(),
		"tiempo_juego": Time.get_ticks_msec() / 1000.0, # Simple, idealmente usar un TimeManager acumulativo
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
		var json_string = JSON.stringify(datos_guardado)
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
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error == OK:
		var datos_guardado = json.data
		_aplicar_datos_cargados(datos_guardado)
		return true
	else:
		push_error("JSON Parse Error: ", json.get_error_message())
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
		DirAccess.remove_absolute(ruta)
		print("Partida borrada: Slot %d" % slot)

func obtener_metadata(slot: int) -> Dictionary:
	if not existe_partida(slot):
		return {}
		
	var archivo = FileAccess.open(obtener_ruta(slot), FileAccess.READ)
	if not archivo: return {}
	
	var json = JSON.new()
	if json.parse(archivo.get_as_text()) == OK:
		var datos = json.data
		return {
			"fecha": datos.get("fecha", "???"),
			"version": datos.get("version", "1.0")
		}
	return {}
