# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCheckpoint.gd
## Punto de control para carreras.
##
## **Uso:** Añade este componente para marcar checkpoints en circuitos.
## Se usa con ComponenteLapManager.
##
## **Casos de uso:**
## - Checkpoints de carrera
## - Puntos de control
## - Validación de vueltas
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteCheckpoint
extends Area2D
const _tool_context = "RuichisLab/Nodos"

# Checkpoint para carreras.
# Debe tener un CollisionShape2D hijo.

@export var indice: int = 1
@export var gestor_carrera: ComponenteLapManager

func _ready():
	body_entered.connect(_on_body_entered)
	
	if not gestor_carrera:
		# Intentar buscarlo en la escena
		gestor_carrera = get_tree().get_first_node_in_group("LapManager")

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		if gestor_carrera:
			gestor_carrera.registrar_checkpoint(indice)
