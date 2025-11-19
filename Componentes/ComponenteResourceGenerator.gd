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
	
	if VariableManager:
		VariableManager.sumar_variable(variable_recurso, cantidad_por_ciclo)
		
		if mostrar_texto_flotante and FloatingTextManager:
			var pos = get_parent().global_position
			FloatingTextManager.mostrar_texto("+" + str(cantidad_por_ciclo), pos, Color.GOLD)

func set_activo(valor: bool):
	activo = valor
	if activo:
		timer.start()
	else:
		timer.stop()
