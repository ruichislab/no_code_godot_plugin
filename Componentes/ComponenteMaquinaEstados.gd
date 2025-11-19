# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMaquinaEstados.gd
## Máquina de estados para IA.
##
## **Uso:** Añade este componente para crear comportamientos complejos de IA.
## Los estados se definen como nodos hijos.
##
## **Casos de uso:**
## - IA de enemigos (Patrullar, Perseguir, Atacar)
## - Jefes con fases
## - NPCs con rutinas
## - Comportamientos del jugador
##
## **Nota:** Cada estado debe heredar de una clase Estado base.
@icon("res://icon.svg")
class_name ComponenteMaquinaEstados
extends Node
const _tool_context = "RuichisLab/Nodos"

# Componente genérico para manejar estados.
# Puede usarse en Jugador, Enemigos, Bosses, etc.

@export var estado_inicial: NodePath
@onready var estado_actual: Estado = get_node(estado_inicial)

func _ready():
	# Esperar a que el dueño esté listo
	await get_parent().ready
	
	for child in get_children():
		if child is Estado:
			child.maquina_estados = self
			child.actor = get_parent() # El padre es el actor (CharacterBody2D, etc)
	
	if estado_actual:
		estado_actual.entrar()

func _process(delta):
	if estado_actual:
		estado_actual.actualizar(delta)

func _physics_process(delta):
	if estado_actual:
		estado_actual.actualizar_fisica(delta)

func _unhandled_input(event):
	if estado_actual:
		estado_actual.manejar_input(event)

func transicion_a(nombre_estado: String, mensaje: Dictionary = {}):
	if not has_node(nombre_estado):
		push_error("MaquinaEstados: No existe el estado " + nombre_estado)
		return
		
	var nuevo_estado = get_node(nombre_estado)
	if nuevo_estado == estado_actual: return
	
	estado_actual.salir()
	estado_actual = nuevo_estado
	estado_actual.entrar(mensaje)
	
	print("Transición: %s -> %s" % [estado_actual.name, nombre_estado])

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if estado_inicial.is_empty():
		warnings.append("Debe asignar un 'Estado Inicial' para que la máquina arranque.")
	
	var tiene_estados = false
	for child in get_children():
		if child is Estado: # Asumiendo que existe la clase Estado
			tiene_estados = true
			break
	
	if not tiene_estados:
		warnings.append("La máquina de estados necesita al menos un nodo hijo que sea de tipo 'Estado'.")
		
	return warnings
