# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteQuestObjective.gd
## Marca un objetivo de misión como completado.
##
## **Uso:** Coloca este componente en objetos/enemigos que son objetivos de misiones.
## Al interactuar/destruir, notifica al GestorMisiones.
##
## **Casos de uso:**
## - Enemigos que deben ser derrotados
## - Objetos que deben ser recolectados
## - Zonas que deben ser exploradas
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteQuestObjective
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var id_objetivo: String = "llegar_cima"
@export var cantidad: int = 1
@export var solo_una_vez: bool = true

var activado: bool = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if activado and solo_una_vez: return
	
	if body.is_in_group("jugador") or body.name == "Jugador":
		completar_objetivo()

func completar_objetivo():
	var gm = _get_quest_manager()
	if gm:
		gm.avanzar_progreso(id_objetivo, cantidad)
		activado = true
		
		if solo_una_vez:
			# Opcional: Desactivar colisión o borrar
			queue_free()

func _get_quest_manager() -> Node:
	if Engine.has_singleton("GestorMisiones"): return Engine.get_singleton("GestorMisiones")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GestorMisiones")
	return null
