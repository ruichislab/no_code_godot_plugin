# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMaquinaEstados.gd
## Gestor de estados finitos (FSM) para IA y lógica compleja.
##
## **Uso:** Añadir como hijo de un personaje. Añadir nodos `RL_State` como hijos de este componente.
## **Características:** Maneja transiciones, ciclo de vida (entrar/salir) y delegación de procesos (update, physics, input).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_StateMachine
extends Node

# --- CONFIGURACIÓN ---
## Ruta al nodo del estado inicial.
@export var estado_inicial: NodePath

## Si es true, imprime en consola cada cambio de estado (útil para debug).
@export var debug: bool = false

# --- ESTADO INTERNO ---
var estado_actual: RL_State = null
var _esta_activo: bool = true

func _ready() -> void:
	# Esperar a que el dueño (CharacterBody2D, etc.) esté listo para evitar condiciones de carrera
	await get_parent().ready
	
	# Inicializar todos los estados hijos
	for child in get_children():
		if child is RL_State:
			child.maquina = self
			child.actor = get_parent()
	
	if not estado_inicial.is_empty():
		var nodo = get_node_or_null(estado_inicial)
		if nodo and nodo is RL_State:
			transicion_a(nodo.name)
		else:
			push_error("RL_StateMachine: El estado inicial asignado no es válido o no es un RL_State.")

func _process(delta: float) -> void:
	if _esta_activo and estado_actual:
		estado_actual.actualizar(delta)

func _physics_process(delta: float) -> void:
	if _esta_activo and estado_actual:
		estado_actual.actualizar_fisica(delta)

func _unhandled_input(event: InputEvent) -> void:
	if _esta_activo and estado_actual:
		estado_actual.manejar_input(event)

## Cambia al nuevo estado indicado por su nombre (nombre del nodo hijo).
## Opcionalmente pasa un diccionario de datos al nuevo estado.
func transicion_a(nombre_estado: String, mensaje: Dictionary = {}) -> void:
	if not has_node(nombre_estado):
		push_error("RL_StateMachine: No existe el estado hijo llamado '%s'." % nombre_estado)
		return
		
	var nuevo_estado = get_node(nombre_estado) as RL_State
	if not nuevo_estado: return

	# Salir del anterior
	if estado_actual:
		estado_actual.salir()
	
	# Cambiar
	var nombre_previo = estado_actual.name if estado_actual else "null"
	estado_actual = nuevo_estado
	
	if debug:
		print("FSM [%s]: %s -> %s" % [get_parent().name, nombre_previo, estado_actual.name])

	# Entrar al nuevo
	estado_actual.entrar(mensaje)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if estado_inicial.is_empty():
		warnings.append("Debe asignar un 'Estado Inicial' para que la máquina arranque.")
	
	var tiene_estados = false
	for child in get_children():
		if child is RL_State:
			tiene_estados = true
			break
	
	if not tiene_estados:
		warnings.append("La máquina de estados necesita al menos un nodo hijo que sea de tipo 'RL_State'.")
		
	return warnings
