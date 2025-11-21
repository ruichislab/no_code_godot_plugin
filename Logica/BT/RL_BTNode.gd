# Archivo: addons/no_code_godot_plugin/Logica/BT/RL_BTNode.gd
## Nodo base para el Árbol de Comportamiento.
## Retorna: EXITO, FALLO, o CORRIENDO.
class_name RL_BTNode
extends Resource

enum Estado { EXITO, FALLO, CORRIENDO }

## Función principal a sobrescribir.
## `actor`: El nodo (NPC/Enemigo) que ejecuta la IA.
## `pizarra`: Diccionario compartido de memoria (Blackboard).
func tick(actor: Node, pizarra: Dictionary) -> int:
	return Estado.FALLO
