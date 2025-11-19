# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/BTAction.gd
class_name BTAction
extends BTNode

@export var accion: GameAction

func tick(actor: Node, blackboard: Blackboard) -> Status:
	if accion:
		accion.ejecutar(actor)
		return Status.SUCCESS
	return Status.FAILURE
