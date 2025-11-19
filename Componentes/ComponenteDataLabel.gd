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
	
	if VariableManager and not actualizar_cada_frame:
		VariableManager.variable_cambiada.connect(_on_variable_cambiada)

func _process(delta):
	if actualizar_cada_frame:
		actualizar_texto()

func _on_variable_cambiada(nombre, valor):
	if nombre == nombre_variable:
		actualizar_texto()

func actualizar_texto():
	var valor = "0"
	if VariableManager:
		valor = str(VariableManager.obtener_valor(nombre_variable))
		
	text = formato % valor
