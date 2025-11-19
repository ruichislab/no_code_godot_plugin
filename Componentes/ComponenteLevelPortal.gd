# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteLevelPortal.gd
## Portal de cambio de nivel.
##
## **Uso:** Añade este componente para crear portales entre niveles.
## Cambia de escena al entrar.
##
## **Casos de uso:**
## - Puertas entre niveles
## - Portales mágicos
## - Escaleras
## - Teletransportadores
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteLevelPortal
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export_file("*.tscn") var escena_destino: String
@export var nombre_punto_aparicion: String = "Inicio"
@export var sonido_entrar: String = "portal_enter"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		viajar()

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func viajar():
	if escena_destino == "": return
	
	print("Viajando a: " + escena_destino)
	
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido_entrar)
		elif sm.has_method("reproducir_sonido") and typeof(sonido_entrar) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido_entrar)
	
	# Guardar datos antes de cambiar si es necesario
	# if SistemaGuardado: SistemaGuardado.guardar_juego()
	
	if SceneManager:
		# SceneManager debería soportar pasar datos, pero por ahora usamos variables globales
		VariableManager.set_valor("next_spawn_point", nombre_punto_aparicion)
		SceneManager.cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)
