# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteVolumeSlider.gd
## Slider de volumen auto-gestionado.
##
## **Uso:** Controla el volumen de un Bus de Audio y guarda la preferencia.
## **Requisito:** HSlider.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_VolumeSlider
extends HSlider

# --- CONFIGURACIÓN ---
@export var nombre_bus: String = "Master"

func _ready() -> void:
	# Configurar rango
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	
	# Obtener valor inicial del SettingsManager si existe
	if Engine.has_singleton("SettingsManager"):
		var sm = Engine.get_singleton("SettingsManager")
		value = sm.call("get_volumen", nombre_bus)
	else:
		# Fallback directo al AudioServer
		var idx = AudioServer.get_bus_index(nombre_bus)
		if idx != -1:
			value = db_to_linear(AudioServer.get_bus_volume_db(idx))
	
	value_changed.connect(_al_cambiar_valor)
	# Guardar al soltar el slider para no spammear disco
	drag_ended.connect(_al_soltar)

func _al_cambiar_valor(nuevo_valor: float) -> void:
	if Engine.has_singleton("SettingsManager"):
		Engine.get_singleton("SettingsManager").call("set_volumen", nombre_bus, nuevo_valor)
	else:
		# Fallback directo
		var idx = AudioServer.get_bus_index(nombre_bus)
		if idx != -1:
			AudioServer.set_bus_volume_db(idx, linear_to_db(nuevo_valor))
			AudioServer.set_bus_mute(idx, nuevo_valor < 0.01)

func _al_soltar(_valor_cambio: bool) -> void:
	if Engine.has_singleton("SettingsManager"):
		Engine.get_singleton("SettingsManager").call("guardar_ajustes")

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if AudioServer.get_bus_index(nombre_bus) == -1:
		warnings.append("El Bus de Audio '%s' no existe en el proyecto." % nombre_bus)
	return warnings
