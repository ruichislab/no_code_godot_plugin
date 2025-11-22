# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteLevelPortal.gd
## Zona que transporta al jugador a otra escena (.tscn).
##
## **Uso:** Puertas, escaleras o portales mágicos.
## **Requisito:** Hijo de Area2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_LevelPortal
extends Area2D

# --- CONFIGURACIÓN ---

## Ruta de la escena destino (.tscn).
@export_file("*.tscn") var escena_destino: String:
	set(val):
		escena_destino = val
		update_configuration_warnings()

## Nombre del Marker2D donde aparecerá el jugador en la nueva escena (ej: "EntradaNorte").
@export var nombre_punto_aparicion: String = "Inicio"

## Sonido al activar el portal (ID de AudioManager).
@export var sonido_entrar: String = "portal_enter"

## Si es true, guarda la partida automáticamente antes de cambiar.
@export var guardar_al_entrar: bool = false

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		viajar()

func viajar() -> void:
	if escena_destino == "":
		push_error("RL_LevelPortal: No hay escena destino asignada.")
		return
	
	# Sonido
	if sonido_entrar != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("reproducir_sfx", sonido_entrar)
	
	# Guardado opcional
	if guardar_al_entrar and Engine.has_singleton("SaveManager"):
		Engine.get_singleton("SaveManager").call("guardar_juego")
	
	# Configurar punto de aparición (Variable Global)
	if Engine.has_singleton("VariableManager"):
		Engine.get_singleton("VariableManager").call("set_valor", "next_spawn_point", nombre_punto_aparicion)
	
	# Cambio de Escena
	if Engine.has_singleton("GameManager"):
		Engine.get_singleton("GameManager").cambiar_escena(escena_destino)
	else:
		get_tree().change_scene_to_file(escena_destino)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if escena_destino == "":
		warnings.append("Asigna una escena destino (.tscn).")
	elif not FileAccess.file_exists(escena_destino):
		warnings.append("La escena destino no existe (Ruta inválida).")

	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo.")
	return warnings
