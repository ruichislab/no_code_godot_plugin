# Archivo: Servicios/InputManager.gd
extends Node

# Configurar como Autoload: "InputManager"
# Permite reasignar teclas en tiempo de ejecución y guardar la configuración.

const RUTA_INPUTS: String = "user://input_map.cfg"

# Lista de acciones que permitimos reasignar (para no romper UI_cancel, etc)
var acciones_configurables: Array[String] = ["arriba", "abajo", "izquierda", "derecha", "interactuar", "atacar", "saltar"]

func _ready():
	cargar_mapeo()

func reasignar_accion(accion: String, evento_input: InputEvent):
	if not acciones_configurables.has(accion):
		push_error("InputManager: La acción '%s' no es configurable." % accion)
		return
		
	# Eliminamos eventos previos para esta acción (para evitar tener 2 teclas para lo mismo)
	InputMap.action_erase_events(accion)
	InputMap.action_add_event(accion, evento_input)
	
	print("InputManager: '%s' reasignado a %s" % [accion, evento_input.as_text()])
	guardar_mapeo()

func guardar_mapeo():
	var config = ConfigFile.new()
	
	for accion in acciones_configurables:
		var eventos = InputMap.action_get_events(accion)
		if eventos.size() > 0:
			# Guardamos solo el primer evento (tecla principal) por simplicidad
			config.set_value("Inputs", accion, eventos[0])
			
	config.save(RUTA_INPUTS)

func cargar_mapeo():
	var config = ConfigFile.new()
	var error = config.load(RUTA_INPUTS)
	if error != OK: return # Usar defecto si no hay archivo
	
	for accion in acciones_configurables:
		var evento = config.get_value("Inputs", accion, null)
		if evento and evento is InputEvent:
			InputMap.action_erase_events(accion)
			InputMap.action_add_event(accion, evento)

func obtener_tecla_actual(accion: String) -> String:
	var eventos = InputMap.action_get_events(accion)
	if eventos.size() > 0:
		return eventos[0].as_text().replace(" (Physical)", "")
	return "Sin Asignar"
