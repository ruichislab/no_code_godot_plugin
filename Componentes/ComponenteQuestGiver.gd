# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteQuestGiver.gd
## NPC o disparador que entrega una misión.
##
## **Uso:** Interactuar con este nodo inicia la misión asignada.
## **Requisito:** Hijo de Area2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_QuestGiver
extends Area2D

# --- CONFIGURACIÓN ---

## Recurso de la misión a entregar.
@export var mision: ResourceMision

## Si es true, la misión se acepta automáticamente al entrar en el área.
@export var autoiniciar: bool = false

## Sonido al entregar misión.
@export var sonido_aceptar: String = "quest_accept"

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador") and body.name != "Jugador": return
	
	if autoiniciar:
		dar_mision()

## Método público para RL_Interaccion.
func interactuar(_actor: Node = null) -> void:
	dar_mision()

func dar_mision() -> void:
	if not mision or not Engine.has_singleton("GestorMisiones"): return

	var gm = Engine.get_singleton("GestorMisiones")
	
	if gm.es_mision_completada(mision.id_mision):
		# Ya hecha
		if Engine.has_singleton("FloatingTextManager"):
			Engine.get_singleton("FloatingTextManager").call("mostrar_texto", "¡Gracias por tu ayuda!", global_position + Vector2(0, -60))
	elif gm.es_mision_activa(mision.id_mision):
		# En progreso
		if Engine.has_singleton("FloatingTextManager"):
			Engine.get_singleton("FloatingTextManager").call("mostrar_texto", "¿Aún no terminas?", global_position + Vector2(0, -60))
	else:
		# Nueva
		gm.aceptar_mision(mision)
		if sonido_aceptar != "" and Engine.has_singleton("AudioManager"):
			Engine.get_singleton("AudioManager").call("reproducir_sfx", sonido_aceptar)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not mision:
		warnings.append("Asigna un 'ResourceMision'.")
	return warnings
