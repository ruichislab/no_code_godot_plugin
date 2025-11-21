# Archivo: addons/no_code_godot_plugin/Logica/BT/RL_BTSequence.gd
## Secuencia (AND Lógico). Ejecuta hijos hasta que uno FALLE.
## Si todos tienen ÉXITO, devuelve ÉXITO.
class_name RL_BTSequence
extends RL_BTComposite

func tick(actor: Node, pizarra: Dictionary) -> int:
	# Nota: Para soportar "CORRIENDO" correctamente en secuencias, se necesitaría guardar el índice del hijo activo en la pizarra.
	# Esta es una implementación simplificada sin memoria entre ticks para nodos stateless.
	for hijo in hijos:
		var resultado = hijo.tick(actor, pizarra)
		if resultado == Estado.FALLO:
			return Estado.FALLO
		if resultado == Estado.CORRIENDO:
			return Estado.CORRIENDO
	return Estado.EXITO
