# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteResourceGenerator.gd
## Generador de recursos pasivo (idle/tycoon).
##
## **Uso:** Añade este componente para generar recursos automáticamente.
## Ideal para juegos idle y tycoon.
##
## **Casos de uso:**
## - Minas que generan oro
## - Granjas que producen comida
## - Fábricas
## - Generadores de energía
##
## **Nota:** Se integra con GameManager para almacenar recursos.
@icon("res://icon.svg")
class_name ComponenteResourceGenerator
extends Node
const _tool_context = "RuichisLab/Nodos"

## Nombre de la variable global a generar (ej: "dinero").
@export var variable_recurso: String = "dinero"
## Cantidad generada por ciclo.
@export var cantidad_por_ciclo: int = 10
## Tiempo en segundos entre cada generación.
@export var tiempo_ciclo: float = 1.0
## Si comienza activo.
@export var activo: bool = true
## Mostrar texto flotante al generar.
@export var mostrar_texto_flotante: bool = true

var timer: Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = tiempo_ciclo
	timer.timeout.connect(_on_timeout)
	
	if activo:
		timer.start()

func _on_timeout():
	if not activo: return
	
	var vm = _get_variable_manager()
	if vm:
		vm.sumar_variable(variable_recurso, cantidad_por_ciclo)
		
		if mostrar_texto_flotante:
			var ftm = _get_floating_text_manager()
			if ftm:
				var pos = get_parent().global_position
				ftm.mostrar_texto("+" + str(cantidad_por_ciclo), pos, Color.GOLD)

func set_activo(valor: bool):
	activo = valor
	if activo:
		timer.start()
	else:
		timer.stop()

func _get_variable_manager() -> Node:
	if Engine.has_singleton("VariableManager"): return Engine.get_singleton("VariableManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("VariableManager")
	return null

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null
