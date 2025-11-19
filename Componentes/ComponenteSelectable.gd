# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSelectable.gd
## Objeto seleccionable con el mouse.
##
## **Uso:** Añade este componente a unidades/objetos que pueden ser seleccionados.
## Muestra feedback visual al hacer hover/seleccionar.
##
## **Casos de uso:**
## - Unidades RTS
## - Piezas de ajedrez
## - Cartas seleccionables
## - Edificios
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteSelectable
extends Area2D
const _tool_context = "RuichisLab/Nodos"

signal seleccionado
signal deseleccionado

@export var grupo_seleccion: String = "unidades"
@export var sprite_seleccion: Sprite2D # Asignar un sprite hijo que se mostrará al seleccionar
@export var solo_en_turno: String = "" # Si se define, solo seleccionable en este turno (requiere TurnManager)

var esta_seleccionado: bool = false
var turn_manager: ComponenteTurnManager

func _ready():
	input_event.connect(_on_input_event)
	if sprite_seleccion:
		sprite_seleccion.visible = false
		
	# Buscar TurnManager si es necesario
	if solo_en_turno != "":
		turn_manager = get_tree().get_first_node_in_group("TurnManager")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		seleccionar()

func seleccionar():
	if solo_en_turno != "" and turn_manager:
		if turn_manager.obtener_equipo_actual() != solo_en_turno:
			return # No es mi turno
			
	# Deseleccionar otros del mismo grupo (comportamiento RTS básico)
	get_tree().call_group(grupo_seleccion, "deseleccionar")
	
	esta_seleccionado = true
	if sprite_seleccion:
		sprite_seleccion.visible = true
	add_to_group("seleccionado") # Grupo temporal
	emit_signal("seleccionado")

func deseleccionar():
	if not esta_seleccionado: return
	
	esta_seleccionado = false
	if sprite_seleccion:
		sprite_seleccion.visible = false
	if is_in_group("seleccionado"):
		remove_from_group("seleccionado")
	emit_signal("deseleccionado")
