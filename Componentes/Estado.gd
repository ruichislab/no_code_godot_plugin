# Archivo: addons/no_code_godot_plugin/Logica/Estado.gd
## Clase base para estados de la Máquina de Estados.
##
## **Uso:** Crea un script nuevo, hereda de esta clase (`extends RL_State`) y añade tu lógica.
## Luego añade el nodo como hijo de una `RL_StateMachine`.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_State
extends Node

# Referencia a la máquina de estados (asignada automáticamente)
var maquina: Node
# Referencia al actor (el nodo raíz, asignado automáticamente)
var actor: Node

# --- MÉTODOS VIRTUALES (Sobrescribe estos) ---

## Se llama al entrar en el estado.
## `mensaje` puede contener datos extra (ej: {"fuerza_salto": 500})
func entrar(_mensaje: Dictionary = {}) -> void:
	pass

## Se llama al salir del estado.
func salir() -> void:
	pass

## Se llama en _process (cada frame).
func actualizar(_delta: float) -> void:
	pass

## Se llama en _physics_process (físicas).
func actualizar_fisica(_delta: float) -> void:
	pass

## Se llama en _unhandled_input (eventos de entrada).
func manejar_input(_event: InputEvent) -> void:
	pass
