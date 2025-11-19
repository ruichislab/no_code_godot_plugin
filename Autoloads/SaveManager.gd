# Archivo: addons/no_code_godot_plugin/Autoloads/SaveManager.gd
## Manager global para guardar y cargar partidas.
##
## **Uso:** Autoload automático. Úsalo con `SaveManager.guardar()`.
##
## **Funciones:**
## - Guardar/cargar datos del juego
## - Múltiples slots de guardado
## - Serialización JSON
## - Comprobación de existencia de guardados

extends Node

const SAVE_DIR = "user://saves/"
const SAVE_EXTENSION = ".save"

var datos_actuales: Dictionary = {}
var slot_actual: int = 0

# Helpers JSON compatibles con varias versiones de Godot
func _json_stringify(obj) -> String:
	var j = JSON.new()
	if j.has_method("stringify"):
		return j.stringify(obj)
	if j.has_method("print"):
		return j.print(obj)
	# Fallback: usar str() si no hay método conocido
	return str(obj)

func _json_parse(text):
	var j = JSON.new()
	var parsed = null
	if j.has_method("parse"):
		parsed = j.parse(text)
	elif j.has_method("parse_string"):
		parsed = j.parse_string(text)
	# No hay fallback global seguro; devolver null si no se pudo parsear
	else:
		return null

	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return parsed

func _ready():
	# Crear directorio de guardado si no existe
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	print("SaveManager: Inicializado. Directorio: ", SAVE_DIR)

## Guarda datos en el slot especificado.
func guardar(slot: int = 0, datos = null):
	slot_actual = slot

	# Normalizar parámetro 'datos' (evitar mutable default)
	if datos == null:
		datos = {}

	# Mezclar datos nuevos con actuales
	for key in datos:
		datos_actuales[key] = datos[key]

	var ruta = _get_save_path(slot)
	var archivo = FileAccess.open(ruta, FileAccess.WRITE)

	if archivo == null:
		push_error("SaveManager: No se pudo abrir el archivo para guardar: %s" % ruta)
		return false

	var json_text = _json_stringify(datos_actuales)
	archivo.store_string(json_text)
	archivo.close()

	print("SaveManager: Guardado en slot ", slot)
	return true

## Carga datos del slot especificado.
func cargar(slot: int = 0) -> Dictionary:
	slot_actual = slot
	var ruta = _get_save_path(slot)

	if not FileAccess.file_exists(ruta):
		push_warning("SaveManager: No existe guardado en slot %d" % slot)
		return {}

	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("SaveManager: No se pudo leer el archivo: %s" % ruta)
		return {}

	var texto = archivo.get_as_text()
	archivo.close()

	var datos = _json_parse(texto)
	if not (datos is Dictionary):
		push_error("SaveManager: Error al parsear JSON en slot %d" % slot)
		return {}

	datos_actuales = datos
	print("SaveManager: Cargado desde slot ", slot)
	return datos_actuales

## Comprueba si existe un guardado en el slot.
func existe_guardado(slot: int = 0) -> bool:
	return FileAccess.file_exists(_get_save_path(slot))

## Borra el guardado del slot.
func borrar_guardado(slot: int = 0):
	var ruta = _get_save_path(slot)
	if FileAccess.file_exists(ruta):
		# Intentar eliminar usando DirAccess si está disponible
		var removed = ERR_UNAVAILABLE
		var rel = ruta
		if ruta.begins_with("user://"):
			rel = ruta.replace("user://", "")
			var dir = DirAccess.open("user://")
			if dir:
				# intentar remove_file (API puede variar entre versiones)
				if dir.has_method("remove_file"):
					removed = dir.remove_file(rel)
				elif dir.has_method("remove"):
					removed = dir.remove(rel)

		# Fallback: truncar el archivo para evitar errores si no se puede borrar
		if removed != OK:
			var f = FileAccess.open(ruta, FileAccess.WRITE)
			if f:
				f.store_string("")
				f.close()
				removed = OK

		if removed == OK:
			print("SaveManager: Borrado slot %d" % slot)
		else:
			push_error("SaveManager: No se pudo borrar el guardado: %s" % ruta)

## Obtiene un valor guardado.
func get_valor(key: String, default = null):
	return datos_actuales.get(key, default)

## Guarda un valor.
func set_valor(key: String, value):
	datos_actuales[key] = value

func _get_save_path(slot: int) -> String:
	return SAVE_DIR + "slot_" + str(slot) + SAVE_EXTENSION
