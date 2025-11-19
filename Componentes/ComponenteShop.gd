# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteShop.gd
## Tienda para comprar/vender items.
##
## **Uso:** Añade este componente a NPCs comerciantes.
## Abre una interfaz de compra/venta al interactuar.
##
## **Casos de uso:**
## - Mercaderes
## - Tiendas de pueblo
## - Vendedores ambulantes
## - Máquinas expendedoras
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere InventarioGlobal activo.
@icon("res://icon.svg")
class_name ComponenteShop
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var item_a_vender: RecursoObjeto
@export var precio: int = 10
@export var moneda_variable: String = "monedas"
@export var sonido_compra: String = "buy_item"
@export var sonido_error: String = "error"

func _ready():
	# Se activa por interacción
	pass

# Llamado por ComponenteInteraccion
func interactuar():
	comprar()

func comprar():
	var vm = _get_variable_manager()
	var inv = _get_inventory_manager()
	
	if not vm or not inv: return
	
	var dinero_actual = vm.obtener_valor(moneda_variable)
	if typeof(dinero_actual) != TYPE_INT and typeof(dinero_actual) != TYPE_FLOAT:
		dinero_actual = 0
		
	if dinero_actual >= precio:
		# Transacción exitosa
		vm.sumar_valor(moneda_variable, -precio)
		inv.anadir_objeto(item_a_vender.id_unico, 1)
		
		print("Compra exitosa: %s por %d" % [item_a_vender.nombre, precio])
		
		var sm = _get_sound_manager()
		if sm:
			# sm.play_sfx(sonido_compra) # SoundManager custom?
			# AudioManager fallback
			pass
			
		var ftm = _get_floating_text_manager()
		if ftm:
			ftm.mostrar_texto("¡Comprado!", global_position + Vector2(0, -50), Color.GREEN)
	else:
		# Fondos insuficientes
		print("No tienes suficiente dinero.")
		var sm = _get_sound_manager()
		if sm:
			# sm.play_sfx(sonido_error)
			pass
			
		var ftm = _get_floating_text_manager()
		if ftm:
			ftm.mostrar_texto("Sin fondos", global_position + Vector2(0, -50), Color.RED)

func _get_variable_manager() -> Node:
	if Engine.has_singleton("VariableManager"): return Engine.get_singleton("VariableManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("VariableManager")
	return null

func _get_inventory_manager() -> Node:
	if Engine.has_singleton("InventarioGlobal"): return Engine.get_singleton("InventarioGlobal")
	if is_inside_tree(): return get_tree().root.get_node_or_null("InventarioGlobal")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null
