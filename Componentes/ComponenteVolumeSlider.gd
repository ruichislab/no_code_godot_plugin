# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteVolumeSlider.gd
## Control deslizante de volumen.
##
## **Uso:** Añade este componente a sliders para controlar el volumen.
## Se conecta automáticamente con el AudioServer.
##
## **Casos de uso:**
## - Control de volumen maestro
## - Control de música
## - Control de efectos de sonido
## - Control de voces
##
## **Requisito:** Debe heredar de HSlider.
@icon("res://icon.svg")
class_name ComponenteVolumeSlider
extends HSlider
const _tool_context = "RuichisLab/Nodos"

@export var bus_name: String = "Master"

var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		push_error("NC_VolumeSlider: Bus de audio '%s' no encontrado." % bus_name)
		return
		
	# Configurar rango
	min_value = 0.0
	max_value = 1.0
	step = 0.05
	
	# Obtener valor actual
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	
	value_changed.connect(_on_value_changed)

func _on_value_changed(nuevo_valor: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(nuevo_valor))
	AudioServer.set_bus_mute(bus_index, nuevo_valor < 0.01)
