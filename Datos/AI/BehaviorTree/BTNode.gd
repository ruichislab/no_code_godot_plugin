# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/BTNode.gd
class_name BTNode
extends Resource

enum Status { SUCCESS, FAILURE, RUNNING }

# Método principal que ejecuta la lógica del nodo.
# Debe ser sobrescrito por los nodos hijos.
func tick(actor: Node, blackboard: Blackboard) -> Status:
	return Status.SUCCESS
