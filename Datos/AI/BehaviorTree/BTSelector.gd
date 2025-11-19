# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/BTSelector.gd
class_name BTSelector
extends BTNode

@export var hijos: Array[BTNode] = []

func tick(actor: Node, blackboard: Blackboard) -> Status:
	for hijo in hijos:
		var resultado = hijo.tick(actor, blackboard)
		if resultado != Status.FAILURE:
			return resultado # Si uno tiene éxito o corre, retornamos eso
	return Status.FAILURE # Todos fallaron
