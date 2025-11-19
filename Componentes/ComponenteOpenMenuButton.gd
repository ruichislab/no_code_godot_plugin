# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteOpenMenuButton.gd
## Botón que abre/cierra menús.
##
## **Uso:** Añade este componente para controlar la visibilidad de menús.
##
## **Casos de uso:**
## - Botón de pausa
## - Botón de inventario
## - Botón de opciones
## - Botón de mapa
##
## **Requisito:** Debe heredar de Button.
@icon("res://icon.svg")
class_name ComponenteOpenMenuButton
extends Button
const _tool_context = "RuichisLab/Nodos"

@export var menu_a_abrir: Control
@export var cerrar_actual: bool = false
@export var usar_uimanager: bool = true

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	if not menu_a_abrir:
		push_warning("NC_OpenMenuButton: No se asignó menú a abrir.")
		return
		
	if usar_uimanager and UIManager:
		UIManager.abrir_menu(menu_a_abrir)
	else:
		# Lógica manual simple
		menu_a_abrir.visible = true
		
		if cerrar_actual:
			# Buscar el menú padre de este botón
			var padre = get_parent()
			while padre and not padre is ComponenteMenuManager and not padre is CanvasLayer:
				padre = padre.get_parent()
			
			if padre and "visible" in padre:
				padre.visible = false
