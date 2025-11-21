# Archivo: addons/no_code_godot_plugin/Servicios/SettingsManager.gd
## Gestor persistente de configuraciones (Audio, Video, Input).
##
## **Uso:** Autoload 'SettingsManager'. Guarda automáticamente en 'user://settings.cfg'.
extends Node

signal volumen_cambiado(bus: String, valor: float)
signal pantalla_completa_cambiada(es_full: bool)

const RUTA_AJUSTES: String = "user://settings.cfg"

var _config: ConfigFile = ConfigFile.new()
var volumenes: Dictionary = { "Master": 1.0, "Music": 1.0, "SFX": 1.0 }
var pantalla_completa: bool = false
var vsync: bool = true

func _ready() -> void:
	cargar_ajustes()

func cargar_ajustes() -> void:
	var error = _config.load(RUTA_AJUSTES)
	if error != OK:
		_guardar_ajustes_iniciales()
		return

	# Audio
	for bus in volumenes.keys():
		var vol = _config.get_value("Audio", bus, 1.0)
		set_volumen(bus, vol, false) # false = no guardar inmediatamente
		
	# Video
	pantalla_completa = _config.get_value("Video", "Fullscreen", false)
	vsync = _config.get_value("Video", "VSync", true)
	_aplicar_video()
	emit_signal("pantalla_completa_cambiada", pantalla_completa)

	# Inputs
	if _config.has_section("Input"):
		for accion in _config.get_section_keys("Input"):
			var eventos = _config.get_value("Input", accion, [])
			if not InputMap.has_action(accion):
				InputMap.add_action(accion)

			InputMap.action_erase_events(accion)
			for evento in eventos:
				InputMap.action_add_event(accion, evento)

func guardar_ajustes() -> void:
	# Audio
	for bus in volumenes.keys():
		_config.set_value("Audio", bus, volumenes[bus])
		
	# Video
	_config.set_value("Video", "Fullscreen", pantalla_completa)
	_config.set_value("Video", "VSync", vsync)

	# Input
	var acciones_a_guardar = InputMap.get_actions()
	for accion in acciones_a_guardar:
		if not accion.begins_with("ui_"):
			var eventos = InputMap.action_get_events(accion)
			_config.set_value("Input", accion, eventos)

	_config.save(RUTA_AJUSTES)

func _guardar_ajustes_iniciales() -> void:
	guardar_ajustes()

# --- API PÚBLICA ---

func set_volumen(bus_nombre: String, valor_lineal: float, guardar_auto: bool = true) -> void:
	volumenes[bus_nombre] = clamp(valor_lineal, 0.0, 1.0)
	
	var bus_idx = AudioServer.get_bus_index(bus_nombre)
	if bus_idx != -1:
		var db = linear_to_db(volumenes[bus_nombre])
		AudioServer.set_bus_volume_db(bus_idx, db)
		AudioServer.set_bus_mute(bus_idx, valor_lineal <= 0.01)
	
	emit_signal("volumen_cambiado", bus_nombre, volumenes[bus_nombre])

	if guardar_auto:
		# Usamos un timer o lógica diferida si queremos optimizar
		pass

func get_volumen(bus_nombre: String) -> float:
	return volumenes.get(bus_nombre, 1.0)

func set_pantalla_completa(valor: bool) -> void:
	pantalla_completa = valor
	_aplicar_video()
	emit_signal("pantalla_completa_cambiada", pantalla_completa)
	guardar_ajustes()

func _aplicar_video() -> void:
	if pantalla_completa:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
