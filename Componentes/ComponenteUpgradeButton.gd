# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteUpgradeButton.gd
## Botón de mejora/upgrade.
##
## **Uso:** Añade este componente para crear sistemas de mejoras.
## Verifica recursos y aplica la mejora al comprar.
##
## **Casos de uso:**
## - Árbol de habilidades
## - Mejoras de stats
## - Upgrades de edificios
## - Tienda de mejoras
##
## **Requisito:** Debe heredar de Button.
@icon("res://icon.svg")
class_name ComponenteUpgradeButton
extends Button
const _tool_context = "RuichisLab/Nodos"

## ID de la mejora (variable booleana).
@export var id_mejora: String = "doble_salto"
## Variable de moneda para pagar.
@export var variable_coste: String = "dinero"
## Coste de la mejora.
@export var coste: int = 100
## Texto del botón antes de comprar.
@export var texto_base: String = "Comprar Doble Salto"

func _ready():
	pressed.connect(_on_pressed)
	actualizar_estado()
	
	# Escuchar cambios en variables para actualizar estado (si VariableManager tiene señal)
	if VariableManager:
		VariableManager.variable_cambiada.connect(func(_nombre, _valor): actualizar_estado())

func actualizar_estado():
	if not VariableManager: return
	
	var ya_comprado = VariableManager.obtener_variable(id_mejora)
	var dinero = VariableManager.obtener_variable(variable_coste)
	
	if ya_comprado:
		text = texto_base + " (Comprado)"
		disabled = true
	else:
		text = "%s (%d %s)" % [texto_base, coste, variable_coste]
		disabled = (dinero < coste)

func _on_pressed():
	if not VariableManager: return
	
	var dinero = VariableManager.obtener_variable(variable_coste)
	if dinero >= coste:
		VariableManager.sumar_variable(variable_coste, -coste)
		VariableManager.definir_variable(id_mejora, true)
		
		if SoundManager:
			SoundManager.play_sfx("upgrade")
			
		actualizar_estado()
