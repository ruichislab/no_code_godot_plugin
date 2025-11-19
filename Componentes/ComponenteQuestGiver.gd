# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteQuestGiver.gd
## Otorga misiones al jugador.
##
## **Uso:** Añade este componente a NPCs que dan misiones.
## Se integra automáticamente con el GestorMisiones.
##
## **Casos de uso:**
## - NPCs que dan misiones principales
## - Tablones de anuncios con misiones secundarias
## - Misiones automáticas al entrar en zonas
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere GestorMisiones activo.
@icon("res://icon.svg")
class_name ComponenteQuestGiver
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var mision: RecursoMision
@export var autoiniciar: bool = false # Si es true, inicia al entrar en el área

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body.is_in_group("jugador") and body.name != "Jugador": return
	
	if autoiniciar:
		dar_mision()
	else:
		# Aquí podríamos mostrar un icono de "!" sobre el NPC
		pass

# Esta función puede ser llamada por un ComponenteInteraccion
func interactuar():
	dar_mision()

func dar_mision():
	if not mision: return
	
	var gm = _get_quest_manager()
	if gm:
		if gm.es_mision_completada(mision.id_mision):
			print("NPC: ¡Gracias por tu ayuda!")
			# Opcional: Diálogo de agradecimiento
		elif gm.es_mision_activa(mision.id_mision):
			print("NPC: ¿Cómo va la tarea?")
			# Opcional: Diálogo de recordatorio
		else:
			gm.aceptar_mision(mision)
			print("NPC: ¡Por favor, ayúdame!")
	else:
		push_error("GestorMisiones no está activo.")

func _get_quest_manager() -> Node:
	if Engine.has_singleton("GestorMisiones"): return Engine.get_singleton("GestorMisiones")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GestorMisiones")
	return null
