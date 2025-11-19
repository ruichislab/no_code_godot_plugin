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

func _ready():
	# Crear directorio de guardado si no existe
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	print("SaveManager: Inicializado. Directorio: ", SAVE_DIR)

## Guarda datos en el slot especificado.
func guardar(slot: int = 0, datos: Dictionary = {}):
	slot_actual = slot
	
	# Mezclar datos nuevos con actuales
	for key in datos:
		datos_actuales[key] = datos[key]
	
	var ruta = _get_save_path(slot)
	var archivo = FileAccess.open(ruta, FileAccess.WRITE)
	
	if archivo == null:
		push_error("SaveManager: No se pudo abrir el archivo para guardar: ", ruta)
		return false
	
	var json = JSON.stringify(datos_actuales, "\t")
	archivo.store_string(json)
	archivo.close()
	
	print("SaveManager: Guardado en slot ", slot)
	return true

## Carga datos del slot especificado.
func cargar(slot: int = 0) -> Dictionary:
	slot_actual = slot
	var ruta = _get_save_path(slot)
	
	if not FileAccess.file_exists(ruta):
		push_warning("SaveManager: No existe guardado en slot ", slot)
		return {}
	
	var archivo = FileAccess.open(ruta, FileAccess.READ)
	if archivo == null:
		push_error("SaveManager: No se pudo leer el archivo: ", ruta)
		return {}
	
	var texto = archivo.get_as_text()
	archivo.close()
	
	var json = JSON.new()
	var error = json.parse(texto)
	
	if error != OK:
		push_error("SaveManager: Error al parsear JSON en slot ", slot)
		return {}
	
	datos_actuales = json.data
	print("SaveManager: Cargado desde slot ", slot)
	return datos_actuales

## Comprueba si existe un guardado en el slot.
func existe_guardado(slot: int = 0) -> bool:
	return FileAccess.file_exists(_get_save_path(slot))

## Borra el guardado del slot.
func borrar_guardado(slot: int = 0):
	var ruta = _get_save_path(slot)
	if FileAccess.file_exists(ruta):
		DirAccess.remove_absolute(ruta)
		print("SaveManager: Borrado slot ", slot)

## Obtiene un valor guardado.
func get_valor(key: String, default = null):
	return datos_actuales.get(key, default)

## Guarda un valor.
func set_valor(key: String, value):
	datos_actuales[key] = value

func _get_save_path(slot: int) -> String:
	return SAVE_DIR + "slot_" + str(slot) + SAVE_EXTENSION
