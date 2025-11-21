# Archivo: addons/no_code_godot_plugin/Logica/BT/Acciones/RL_BTActionLog.gd
## Acción simple: Imprimir mensaje.
class_name RL_BTActionLog
extends RL_BTNode

@export var mensaje: String = "Hola IA"

func tick(_actor: Node, _pizarra: Dictionary) -> int:
	print("[BT]: ", mensaje)
	return Estado.EXITO
