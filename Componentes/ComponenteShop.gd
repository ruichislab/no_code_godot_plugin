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
	if not VariableManager or not InventarioGlobal: return
	
	var dinero_actual = VariableManager.obtener_valor(moneda_variable)
	if typeof(dinero_actual) != TYPE_INT and typeof(dinero_actual) != TYPE_FLOAT:
		dinero_actual = 0
		
	if dinero_actual >= precio:
		# Transacción exitosa
		VariableManager.sumar_valor(moneda_variable, -precio)
		InventarioGlobal.anadir_objeto(item_a_vender.id_unico, 1)
		
		print("Compra exitosa: %s por %d" % [item_a_vender.nombre, precio])
		
		if SoundManager:
			SoundManager.play_sfx(sonido_compra)
			
		if FloatingTextManager:
			FloatingTextManager.mostrar_texto("¡Comprado!", global_position + Vector2(0, -50), Color.GREEN)
	else:
		# Fondos insuficientes
		print("No tienes suficiente dinero.")
		if SoundManager:
			SoundManager.play_sfx(sonido_error)
			
		if FloatingTextManager:
			FloatingTextManager.mostrar_texto("Sin fondos", global_position + Vector2(0, -50), Color.RED)
