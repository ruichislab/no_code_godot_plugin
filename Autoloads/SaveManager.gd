# Archivo: addons/no_code_godot_plugin/Autoloads/SaveManager.gd
## Sistema de guardado y carga de partidas.
##
## Gestiona la persistencia de datos del juego en formato JSON.
## Soporta múltiples slots, metadata y versiones.
extends Node

# --- CONFIGURACIÓN ---
const PREFIJO_ARCHIVO: String = "user://savegame_"
const EXTENSION: String = ".save"

# --- FUNCIONES PRINCIPALES ---

## Obtiene la ruta completa del archivo para un slot dado.
func obtener_ruta(slot: int) -> String:
	return PREFIJO_ARCHIVO + str(slot) + EXTENSION

## Guarda el estado actual del juego en el slot especificado.
func guardar_juego(slot: int = 1) -> void:
	# print("Iniciando guardado de juego en Slot %d..." % slot)

	var datos_guardado: Dictionary = {
		"version": "1.0",
		"fecha": int(Time.get_unix_time_from_system()),
		"tiempo_juego": Time.get_ticks_msec() / 1000.0,
		"datos_jugador": {},
		"datos_inventario": {},
		"posicion_jugador": {}
	}

	# 1. Recopilar datos del Jugador (Estadísticas y Posición)
	if Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		var jugador = gm.get("jugador")
		if is_instance_valid(jugador):
			# Estadísticas
			var estadisticas = jugador.get_node_or_null("Estadisticas")
			if estadisticas and estadisticas.has_method("guardar_datos"):
				datos_guardado["datos_jugador"] = estadisticas.guardar_datos()

			# Posición
			datos_guardado["posicion_jugador"] = {
				"x": jugador.global_position.x,
				"y": jugador.global_position.y
			}

	# 2. Recopilar datos del Inventario (si el singleton existe)
	if Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")
		if inv.has_method("guardar_datos"):
			datos_guardado["datos_inventario"] = inv.guardar_datos()

	# 3. Recopilar datos de Misiones (si el singleton existe)
	if Engine.has_singleton("GestorMisiones"):
		var misiones = Engine.get_singleton("GestorMisiones")
		if misiones.has_method("guardar_datos"):
			datos_guardado["datos_misiones"] = misiones.guardar_datos()

	# 4. Escribir en disco usando FileAccess (Godot 4)
	var ruta: String = obtener_ruta(slot)
	var archivo: FileAccess = FileAccess.open(ruta, FileAccess.WRITE)

	if archivo:
		var json_string: String = JSON.stringify(datos_guardado, "\t") # Identación para legibilidad
		archivo.store_string(json_string)
		archivo.close()
		# print("Juego guardado exitosamente en: " + ruta)
	else:
		push_error("Error al intentar guardar el archivo: " + error_string(FileAccess.get_open_error()))

## Carga el juego desde el slot especificado.
func cargar_juego(slot: int = 1) -> bool:
	var ruta: String = obtener_ruta(slot)
	if not FileAccess.file_exists(ruta):
		# print("No existe archivo de guardado en Slot %d." % slot)
		return false

	var archivo: FileAccess = FileAccess.open(ruta, FileAccess.READ)
	if not archivo:
		push_error("Error al leer archivo de guardado: " + error_string(FileAccess.get_open_error()))
		return false

	var json_string: String = archivo.get_as_text()
	archivo.close()

	# Parsing JSON seguro
	var json: JSON = JSON.new()
	var error: int = json.parse(json_string)
	if error == OK:
		var datos_guardado = json.data
		if typeof(datos_guardado) == TYPE_DICTIONARY:
			_aplicar_datos_cargados(datos_guardado)
			return true
		else:
			push_error("Error de formato: El archivo de guardado no contiene un diccionario.")
			return false
	else:
		push_error("Error al parsear JSON en línea %d: %s" % [json.get_error_line(), json.get_error_message()])
		return false

func _aplicar_datos_cargados(datos: Dictionary) -> void:
	# print("Aplicando datos cargados...")

	# 1. Cargar Inventario
	if datos.has("datos_inventario") and Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")
		if inv.has_method("cargar_datos"):
			inv.cargar_datos(datos.datos_inventario)

	# 2. Cargar Misiones
	if datos.has("datos_misiones") and Engine.has_singleton("GestorMisiones"):
		var misiones = Engine.get_singleton("GestorMisiones")
		if misiones.has_method("cargar_datos"):
			misiones.cargar_datos(datos.datos_misiones)

	# 3. Cargar Jugador
	if Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		var jugador = gm.get("jugador")
		if is_instance_valid(jugador):
			# Posición
			if datos.has("posicion_jugador"):
				var pos = datos.posicion_jugador
				jugador.global_position = Vector2(pos.x, pos.y)

			# Estadísticas
			if datos.has("datos_jugador"):
				var estadisticas = jugador.get_node_or_null("Estadisticas")
				if estadisticas and estadisticas.has_method("cargar_datos"):
					estadisticas.cargar_datos(datos.datos_jugador)

	# print("Carga completada.")

## Verifica si existe una partida guardada en el slot.
func existe_partida(slot: int = 1) -> bool:
	return FileAccess.file_exists(obtener_ruta(slot))

## Borra la partida del slot especificado.
func borrar_partida(slot: int = 1) -> void:
	var ruta: String = obtener_ruta(slot)

	# Godot 4 usa DirAccess para borrar archivos de manera estática
	if FileAccess.file_exists(ruta):
		var error: int = DirAccess.remove_absolute(ruta)
		if error == OK:
			# print("Partida borrada: Slot %d" % slot)
			pass
		else:
			push_error("No se pudo borrar la partida: %s (Error %d)" % [ruta, error])

## Obtiene metadatos básicos de un slot sin cargar todo el juego.
func obtener_metadata(slot: int) -> Dictionary:
	if not existe_partida(slot):
		return {}

	var archivo: FileAccess = FileAccess.open(obtener_ruta(slot), FileAccess.READ)
	if not archivo:
		return {}

	var texto: String = archivo.get_as_text()
	archivo.close()

	var json: JSON = JSON.new()
	if json.parse(texto) == OK and typeof(json.data) == TYPE_DICTIONARY:
		var datos: Dictionary = json.data
		return {
			"fecha": datos.get("fecha", 0),
			"version": datos.get("version", "1.0"),
			"tiempo_juego": datos.get("tiempo_juego", 0.0)
		}
	return {}
