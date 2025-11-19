# Archivo: Datos/Acciones/AccionVariable.gd
class_name AccionVariable
extends GameAction

enum Operacion { SET, SUMAR, TOGGLE }

@export var nombre_variable: String = "mi_variable"
@export var operacion: Operacion = Operacion.SET
@export var valor: float = 1.0 # Usado para SET y SUMAR

func ejecutar(nodo_origen: Node = null):
	if not VariableManager: return
	
	match operacion:
		Operacion.SET:
			VariableManager.set_valor(nombre_variable, valor)
		Operacion.SUMAR:
			VariableManager.sumar_valor(nombre_variable, valor)
		Operacion.TOGGLE:
			VariableManager.toggle_valor(nombre_variable)
