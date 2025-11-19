# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteKey.gd
## Llave coleccionable para abrir puertas.
##
## **Uso:** Añade este componente a objetos que funcionan como llaves.
## Al recogerlas, se añaden al inventario global.
##
## **Casos de uso:**
## - Llaves de puertas
## - Tarjetas de acceso
## - Gemas para portales
## - Tokens especiales
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteKey
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var id_llave: String = "llave_roja"
@export var sonido: String = "key_pickup"

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		recoger()

func recoger():
	if VariableManager:
		VariableManager.set_valor(id_llave, true)
		print("Llave recogida: " + id_llave)
		
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido)
		elif sm.has_method("reproducir_sonido") and typeof(sonido) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido)
		
	queue_free()
