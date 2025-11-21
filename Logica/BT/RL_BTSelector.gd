# Archivo: addons/no_code_godot_plugin/Logica/BT/RL_BTSelector.gd
## Selector (OR Lógico). Ejecuta hijos hasta que uno tenga ÉXITO.
## Si uno devuelve CORRIENDO, devuelve CORRIENDO.
class_name RL_BTSelector
extends RL_BTComposite

func tick(actor: Node, pizarra: Dictionary) -> int:
	for hijo in hijos:
		var resultado = hijo.tick(actor, pizarra)
		if resultado == Estado.EXITO:
			return Estado.EXITO
		if resultado == Estado.CORRIENDO:
			return Estado.CORRIENDO
	return Estado.FALLO
