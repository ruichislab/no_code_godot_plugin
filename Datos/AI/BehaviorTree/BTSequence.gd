# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/BTSequence.gd
class_name BTSequence
extends BTNode

@export var hijos: Array[BTNode] = []

func tick(actor: Node, blackboard: Blackboard) -> Status:
	for hijo in hijos:
		var resultado = hijo.tick(actor, blackboard)
		if resultado != Status.SUCCESS:
			return resultado # Si uno falla o está corriendo, la secuencia se detiene
	return Status.SUCCESS # Todos tuvieron éxito
