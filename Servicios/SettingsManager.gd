# Archivo: Servicios/SettingsManager.gd
extends Node

# Configurar como Autoload: "SettingsManager"

const RUTA_AJUSTES: String = "user://settings.cfg"

# --- VALORES POR DEFECTO ---
var config = ConfigFile.new()
var volumenes: Dictionary = { "Master": 1.0, "Music": 1.0, "SFX": 1.0 }
var pantalla_completa: bool = false
var vsync: bool = true

func _ready():
	cargar_ajustes()

func cargar_ajustes():
	var error = config.load(RUTA_AJUSTES)
	if error != OK:
		print("SettingsManager: No se encontró configuración previa, usando valores por defecto.")
		guardar_ajustes() # Crear archivo inicial
		return

	# Audio
	for bus in volumenes.keys():
		var vol = config.get_value("Audio", bus, 1.0)
		set_volumen(bus, vol)
		
	# Video
	pantalla_completa = config.get_value("Video", "Fullscreen", false)
	vsync = config.get_value("Video", "VSync", true)
	
	_aplicar_video()

func guardar_ajustes():
	# Audio
	for bus in volumenes.keys():
		config.set_value("Audio", bus, volumenes[bus])
		
	# Video
	config.set_value("Video", "Fullscreen", pantalla_completa)
	config.set_value("Video", "VSync", vsync)
	
	config.save(RUTA_AJUSTES)

# --- API PÚBLICA ---

func set_volumen(bus_nombre: String, valor_lineal: float):
	# valor_lineal: 0.0 a 1.0
	volumenes[bus_nombre] = clamp(valor_lineal, 0.0, 1.0)
	
	var bus_idx = AudioServer.get_bus_index(bus_nombre)
	if bus_idx != -1:
		var db = linear_to_db(volumenes[bus_nombre])
		AudioServer.set_bus_volume_db(bus_idx, db)
		AudioServer.set_bus_mute(bus_idx, valor_lineal <= 0.01)
	
	guardar_ajustes()

func set_pantalla_completa(valor: bool):
	pantalla_completa = valor
	_aplicar_video()
	guardar_ajustes()

func _aplicar_video():
	if pantalla_completa:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
