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
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	
	if Engine.has_singleton("SettingsManager"):
		var sm = Engine.get_singleton("SettingsManager")
		value = sm.call("get_volumen", nombre_bus)

		# Conectar señal para actualizar UI si cambia externamente
		if sm.has_signal("volumen_cambiado"):
			sm.volumen_cambiado.connect(_al_cambiar_externo)
	else:
		var idx = AudioServer.get_bus_index(nombre_bus)
		if idx != -1:
			value = db_to_linear(AudioServer.get_bus_volume_db(idx))
	
	value_changed.connect(_al_cambiar_valor)
	drag_ended.connect(_al_soltar)

func _al_cambiar_valor(nuevo_valor: float) -> void:
	if Engine.has_singleton("SettingsManager"):
		# Llamar set_volumen pero sin guardar a disco en cada frame
		var sm = Engine.get_singleton("SettingsManager")
		if sm.has_method("set_volumen"):
			sm.set_volumen(nombre_bus, nuevo_valor, false)
	else:
		var idx = AudioServer.get_bus_index(nombre_bus)
		if idx != -1:
			AudioServer.set_bus_volume_db(idx, linear_to_db(nuevo_valor))
			AudioServer.set_bus_mute(idx, nuevo_valor < 0.01)

func _al_soltar(_val: bool) -> void:
	if Engine.has_singleton("SettingsManager"):
		Engine.get_singleton("SettingsManager").call("guardar_ajustes")

func _al_cambiar_externo(bus: String, vol: float) -> void:
	if bus == nombre_bus and value != vol:
		set_value_no_signal(vol)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if AudioServer.get_bus_index(nombre_bus) == -1:
		warnings.append("El Bus de Audio '%s' no existe." % nombre_bus)
	return warnings
