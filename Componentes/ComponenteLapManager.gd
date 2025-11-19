# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteLapManager.gd
## Gestor de vueltas para carreras.
##
## **Uso:** Añade este componente para contar vueltas en circuitos.
## Detecta cuando se completa una vuelta.
##
## **Casos de uso:**
## - Juegos de carreras
## - Time trials
## - Circuitos
##
## **Nota:** Requiere ComponenteCheckpoint en el circuito.
@icon("res://icon.svg")
class_name ComponenteLapManager
extends Node
const _tool_context = "RuichisLab/Nodos"

# Gestor de Carreras. Controla vueltas y checkpoints.

signal vuelta_completada(numero_vuelta: int)
signal carrera_terminada()
signal checkpoint_pasado(indice: int)

@export var total_vueltas: int = 3
@export var total_checkpoints: int = 0 # Se puede autodetectar

var vuelta_actual: int = 1
var checkpoint_actual: int = 0 # Último checkpoint válido

func _ready():
	# Autodetectar checkpoints si son hijos de un nodo específico o grupo
	pass

func registrar_checkpoint(indice: int):
	# Lógica simple: Debes pasar los checkpoints en orden (0 -> 1 -> 2 -> 0...)
	var siguiente = checkpoint_actual + 1
	
	# Si es el último checkpoint y volvemos al 0 (meta), cuenta vuelta
	if indice == 0 and checkpoint_actual == total_checkpoints:
		_completar_vuelta()
		checkpoint_actual = 0
		return

	if indice == siguiente:
		checkpoint_actual = indice
		emit_signal("checkpoint_pasado", indice)
		print("Checkpoint %d alcanzado" % indice)

func _completar_vuelta():
	print("Vuelta %d completada!" % vuelta_actual)
	emit_signal("vuelta_completada", vuelta_actual)
	
	if vuelta_actual >= total_vueltas:
		print("¡CARRERA TERMINADA!")
		emit_signal("carrera_terminada")
	else:
		vuelta_actual += 1
