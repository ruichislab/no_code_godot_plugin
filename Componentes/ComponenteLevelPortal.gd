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

func viajar():
	if escena_destino == "": return
	
	print("Viajando a: " + escena_destino)
	
	if SoundManager:
		SoundManager.play_sfx(sonido_entrar)
	
	# Guardar datos antes de cambiar si es necesario
	# if SistemaGuardado: SistemaGuardado.guardar_juego()
	
	if SceneManager:
		# SceneManager debería soportar pasar datos, pero por ahora usamos variables globales
		VariableManager.set_valor("next_spawn_point", nombre_punto_aparicion)
		SceneManager.cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)
