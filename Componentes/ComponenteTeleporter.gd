# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd
## Teletransportador a otra posición.
##
## **Uso:** Añade este componente para crear teletransportadores.
## Mueve al jugador a otra posición instantáneamente.
##
## **Casos de uso:**
## - Portales
## - Teletransportadores
## - Trampas de caída
## - Atajos secretos
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteTeleporter
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var destino: Node2D
@export var sonido_teleport: String = "teleport"

func _ready():
	body_entered.connect(_on_body_entered)

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _on_body_entered(body):
	if not destino:
		push_warning("NC_Teleporter: No tiene destino asignado.")
		return
		
	if body is Node2D:
		# Reproducir sonido
		var sm = _get_sound_manager()
		if sm:
			if sm.has_method("play_sfx"):
				sm.play_sfx(sonido_teleport)
			elif sm.has_method("reproducir_sonido") and typeof(sonido_teleport) == TYPE_OBJECT:
				sm.reproducir_sonido(sonido_teleport)
			
		# Teletransportar
		body.global_position = destino.global_position
		
		# Resetear velocidad si es físico
		if "velocity" in body:
			body.velocity = Vector2.ZERO
