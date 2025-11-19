# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDataLabel.gd
## Etiqueta que muestra datos del GameManager.
##
## **Uso:** Añade este componente para mostrar variables globales.
## Se actualiza automáticamente cuando cambian.
##
## **Casos de uso:**
## - Contador de monedas
## - Puntuación
## - Tiempo transcurrido
## - Vidas restantes
##
## **Requisito:** Debe heredar de Label.
@icon("res://icon.svg")
class_name ComponenteDataLabel
extends Label
const _tool_context = "RuichisLab/Nodos"

@export var nombre_variable: String = "monedas"
@export var formato: String = "Monedas: %s"
@export var actualizar_cada_frame: bool = false

func _ready():
	actualizar_texto()
	
	var vm = _get_variable_manager()
	if vm and not actualizar_cada_frame:
		vm.variable_cambiada.connect(_on_variable_cambiada)

func _process(delta):
	if actualizar_cada_frame:
		actualizar_texto()

func _on_variable_cambiada(nombre, valor):
	if nombre == nombre_variable:
		actualizar_texto()

func actualizar_texto():
	var valor = "0"
	var vm = _get_variable_manager()
	if vm:
		valor = str(vm.obtener_valor(nombre_variable))
		
	text = formato % valor

func _get_variable_manager() -> Node:
	if Engine.has_singleton("VariableManager"): return Engine.get_singleton("VariableManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("VariableManager")
	return null
