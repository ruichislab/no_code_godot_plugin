# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInventoryGrid.gd
## Grid visual del inventario.
##
## **Uso:** Añade este componente para mostrar el inventario en pantalla.
## Se actualiza automáticamente cuando cambia el inventario.
##
## **Casos de uso:**
## - Inventario del jugador
## - Tiendas
## - Cofres
## - Almacenes
##
## **Requisito:** Debe heredar de GridContainer. Requiere InventarioGlobal.
@icon("res://icon.svg")
class_name ComponenteInventoryGrid
extends GridContainer
const _tool_context = "RuichisLab/Nodos"

## Escena base para cada slot (debe tener un script con set_item).
@export var item_slot_scene: PackedScene 
## Filtro opcional: "consumible", "equipable", o vacío para todo.
@export var filtrar_por_tipo: String = "" 
## Mostrar cantidad en el botón.
@export var mostrar_cantidad: bool = true

func _ready():
	# Conectar señal de actualización del inventario
	if InventarioGlobal:
		InventarioGlobal.inventario_actualizado.connect(actualizar_grid)
		actualizar_grid()

func actualizar_grid():
	# Limpiar hijos
	for child in get_children():
		child.queue_free()
		
	if not InventarioGlobal: return
	
	var items = InventarioGlobal.obtener_todos_los_items()
	
	for item_data in items:
		var recurso = item_data["recurso"]
		var cantidad = item_data["cantidad"]
		
		# Filtro opcional
		# if filtrar_por_tipo != "" and recurso.tipo != filtrar_por_tipo: continue
		
		if item_slot_scene:
			var slot = item_slot_scene.instantiate()
			add_child(slot)
			
			# Intentar configurar el slot
			if slot.has_method("configurar"):
				slot.configurar(recurso, cantidad)
			elif slot.has_method("set_item"):
				slot.set_item(recurso)
				
			# Si es un botón simple, poner icono y texto
			elif slot is Button:
				slot.text = recurso.nombre
				if mostrar_cantidad:
					slot.text += " x" + str(cantidad)
				if recurso.icono:
					slot.icon = recurso.icono
					slot.expand_icon = true
