# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInventoryGrid.gd
## Grid visual que muestra el contenido del inventario.
##
## **Uso:** UI de Inventario. Se conecta automáticamente al InventarioGlobal.
## **Requisito:** GridContainer.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_InventoryGrid
extends GridContainer

# --- CONFIGURACIÓN ---

## Escena que representa un slot (debe tener método `configurar(item, cantidad)`).
@export var escena_slot: PackedScene

## Filtro de tipo de item (opcional).
@export var filtro_tipo: String = ""

## Si es true, muestra el contador de cantidad en los slots.
@export var mostrar_cantidad: bool = true

func _ready() -> void:
	# Conectar señal de actualización
	if Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")
		if inv.has_signal("inventario_actualizado"):
			inv.inventario_actualizado.connect(actualizar_grid)

		# Actualización inicial
		actualizar_grid()

func actualizar_grid() -> void:
	# Limpiar hijos
	for child in get_children():
		child.queue_free()
	
	if not Engine.has_singleton("InventarioGlobal"): return
	var inv = Engine.get_singleton("InventarioGlobal")
	
	# Obtener items (adaptado a la estructura del InventarioGlobal)
	# Asumimos que el inventario expone una lista o método para obtener items
	var items: Array = []
	if inv.has_method("obtener_todos_los_items"):
		items = inv.obtener_todos_los_items()
	elif "items" in inv:
		items = inv.items
	
	for item_data in items:
		# Verificar estructura de datos (puede ser recurso o diccionario)
		var recurso = item_data.get("recurso") if item_data is Dictionary else item_data
		var cantidad = item_data.get("cantidad", 1) if item_data is Dictionary else 1
		
		if not recurso: continue
		
		# Filtrar
		if filtro_tipo != "" and recurso.get("tipo") != filtro_tipo:
			continue

		# Instanciar Slot
		if escena_slot:
			var slot = escena_slot.instantiate()
			add_child(slot)
			
			if slot.has_method("configurar"):
				slot.configurar(recurso, cantidad)
			elif slot.has_method("set_item"):
				slot.set_item(recurso)

			# Configuración básica de botón si no es un script custom complejo
			if slot is Button:
				var nombre = recurso.get("nombre", "Item")
				var icono = recurso.get("icono", null)
				
				slot.text = nombre
				if mostrar_cantidad and cantidad > 1:
					slot.text += " x%d" % cantidad
				if icono:
					slot.icon = icono
					slot.expand_icon = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not escena_slot:
		warnings.append("Asigna una 'Escena Slot' para visualizar los items.")
	return warnings
