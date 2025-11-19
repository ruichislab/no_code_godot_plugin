# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInputListener.gd
## Escucha inputs del jugador y ejecuta acciones.
##
## **Uso:** Añade este nodo para detectar cuando se presiona una tecla específica
## y ejecutar acciones personalizadas sin escribir código.
##
## **Casos de uso:**
## - Abrir menús con teclas (ESC, Tab, I)
## - Activar habilidades especiales (Q, E, R)
## - Interacciones contextuales (E para interactuar)
## - Atajos de teclado personalizados
##
## **Nota:** Usa nombres de acciones definidas en Project Settings > Input Map.
@icon("res://icon.svg")
class_name ComponenteInputListener
extends Node
const _tool_context = "RuichisLab/Nodos"

signal presionado()
signal soltado()
signal mantenido(delta)

@export var accion: String = "ui_accept"
@export var activo: bool = true

func _process(delta):
	if not activo: return
	
	if Input.is_action_just_pressed(accion):
		emit_signal("presionado")
		print("InputListener: %s presionado" % accion)
		
	if Input.is_action_just_released(accion):
		emit_signal("soltado")
		
	if Input.is_action_pressed(accion):
		emit_signal("mantenido", delta)
