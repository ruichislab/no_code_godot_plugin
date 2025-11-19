# Archivo: Datos/Acciones/AccionVariable.gd
class_name AccionVariable
extends GameAction

enum Operacion { SET, SUMAR, TOGGLE }

@export var nombre_variable: String = "mi_variable"
@export var operacion: Operacion = Operacion.SET
@export var valor: float = 1.0 # Usado para SET y SUMAR

func _get_variable_manager():
	if Engine.has_singleton("VariableManager"):
		return Engine.get_singleton("VariableManager")
	return null

func ejecutar(nodo_origen: Node = null):
	var vm = _get_variable_manager()
	if not vm: return
	
	match operacion:
		Operacion.SET:
			vm.set_valor(nombre_variable, valor)
		Operacion.SUMAR:
			vm.sumar_valor(nombre_variable, valor)
		Operacion.TOGGLE:
			vm.toggle_valor(nombre_variable)
