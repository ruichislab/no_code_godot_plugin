# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/BTCondition.gd
class_name BTCondition
extends BTNode

enum TipoCheck { BLACKBOARD, VARIABLE_GLOBAL }
enum Operador { IGUAL, MAYOR, MENOR, DISTINTO }

@export var tipo: TipoCheck = TipoCheck.BLACKBOARD
@export var clave: String = ""
@export var operador: Operador = Operador.IGUAL
@export var valor_comparar: float = 0.0 # Simplificado a float/bool

func tick(actor: Node, blackboard: Blackboard) -> Status:
	var valor_actual
	
	if tipo == TipoCheck.BLACKBOARD:
		valor_actual = blackboard.get_valor(clave, 0.0)
	else:
		if VariableManager:
			valor_actual = VariableManager.get_valor(clave, 0.0)
		else:
			return Status.FAILURE

	# Comparación simple (asumiendo números)
	var cumple = false
	match operador:
		Operador.IGUAL: cumple = is_equal_approx(valor_actual, valor_comparar)
		Operador.MAYOR: cumple = valor_actual > valor_comparar
		Operador.MENOR: cumple = valor_actual < valor_comparar
		Operador.DISTINTO: cumple = not is_equal_approx(valor_actual, valor_comparar)
		
	return Status.SUCCESS if cumple else Status.FAILURE
