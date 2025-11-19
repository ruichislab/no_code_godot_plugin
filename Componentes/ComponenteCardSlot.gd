class_name ComponenteCardSlot
extends PanelContainer
const _tool_context = "RuichisLab/Nodos"

signal carta_depositada(carta)

## Filtro opcional por ID de carta o tipo.
@export var filtro_id: String = ""

func _can_drop_data(_at_position, data):
	# El sistema de drag&drop nativo de Godot usa esto.
	# ComponenteCard debe devolver 'self' o un diccionario en _get_drag_data.
	if data is Node and data.has_method("get_card_data"):
		if filtro_id != "" and data.get_card_data().id != filtro_id:
			return false
		return true
	return false

func _drop_data(_at_position, data):
	if data is Node:
		# Reparentar la carta a este slot
		var old_parent = data.get_parent()
		old_parent.remove_child(data)
		add_child(data)
		data.position = Vector2.ZERO # Centrar
		emit_signal("carta_depositada", data)