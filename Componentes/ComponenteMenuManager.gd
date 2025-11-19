# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteMenuManager.gd
## Gestor de navegación entre menús.
##
## **Uso:** Añade este componente al nodo raíz de tu UI.
## Maneja la navegación entre diferentes paneles de menú.
##
## **Casos de uso:**
## - Menú principal
## - Menú de pausa
## - Sistema de opciones
## - Menús anidados
##
## **Requisito:** Debe heredar de Control.
@icon("res://icon.svg")
class_name ComponenteMenuManager
extends Control
const _tool_context = "RuichisLab/Nodos"

@export var foco_inicial: Control
@export var cerrar_con_escape: bool = true
@export var pausar_juego: bool = false

func _ready():
	# Si es visible al inicio, tomar foco
	if visible:
		tomar_foco()
		
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
	if visible:
		tomar_foco()
		if pausar_juego:
			get_tree().paused = true
	else:
		if pausar_juego:
			get_tree().paused = false

func tomar_foco():
	if foco_inicial:
		foco_inicial.grab_focus()
	else:
		# Buscar primer botón
		var boton = _buscar_primer_boton(self)
		if boton:
			boton.grab_focus()

func _buscar_primer_boton(nodo: Node) -> Control:
	for child in nodo.get_children():
		if child is BaseButton and child.visible and not child.disabled:
			return child
		if child.get_child_count() > 0:
			var encontrado = _buscar_primer_boton(child)
			if encontrado: return encontrado
	return null

func _input(event):
	if not visible: return
	
	if cerrar_con_escape and event.is_action_pressed("ui_cancel"):
		cerrar()
		get_viewport().set_input_as_handled()

func cerrar():
	visible = false
	# Si UIManager está presente, notificarle (opcional si no usamos UIManager.abrir_menu)
	# Si UIManager está presente, notificarle (opcional si no usamos UIManager.abrir_menu)
	var uim = _get_ui_manager()
	if uim and uim.pila_menus.has(self):
		uim.cerrar_menu_actual()

func _get_ui_manager() -> Node:
	if Engine.has_singleton("UIManager"): return Engine.get_singleton("UIManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("UIManager")
	return null
