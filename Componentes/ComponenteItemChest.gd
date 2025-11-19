# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteItemChest.gd
## Cofre que otorga items al abrirse.
##
## **Uso:** Añade este componente a cofres u objetos que contienen items.
## Al interactuar, añade los items al inventario del jugador.
##
## **Casos de uso:**
## - Cofres de tesoro
## - Cajas de botín
## - Recompensas ocultas
## - Drops de jefes
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteItemChest
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var id_cofre: String = "cofre_01"
@export var item_contenido: RecursoObjeto
@export var cantidad: int = 1
@export var sprite_cerrado: Texture2D
@export var sprite_abierto: Texture2D
@export var sonido_abrir: String = "chest_open"

var abierto: bool = false
var sprite_node: Sprite2D

func _ready():
	# Buscar o crear Sprite2D
	sprite_node = get_node_or_null("Sprite2D")
	if not sprite_node:
		sprite_node = Sprite2D.new()
		sprite_node.name = "Sprite2D"
		add_child(sprite_node)
		
	# Cargar estado
	# Cargar estado
	var vm = _get_variable_manager()
	if vm:
		var val = vm.obtener_valor("chest_" + id_cofre)
		if val != null:
			abierto = val
		
	_actualizar_visual()

# Llamado por ComponenteInteraccion o input manual
func interactuar():
	if abierto: return
	
	abrir()

func abrir():
	abierto = true
	
	# Guardar estado
	# Guardar estado
	var vm = _get_variable_manager()
	if vm:
		vm.set_valor("chest_" + id_cofre, true)
	
	# Dar item
	var inv = _get_inventory_manager()
	if item_contenido and inv:
		inv.anadir_objeto(item_contenido.id_unico, cantidad)
		print("Obtenido: %s x%d" % [item_contenido.nombre, cantidad])
		
		var ftm = _get_floating_text_manager()
		if ftm:
			ftm.mostrar_texto("+%s" % item_contenido.nombre, global_position + Vector2(0, -40), Color.GOLD)
	
	# Sonido
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx(sonido_abrir)
		pass
		
	_actualizar_visual()

func _actualizar_visual():
	if sprite_node:
		if abierto and sprite_abierto:
			sprite_node.texture = sprite_abierto
		elif not abierto and sprite_cerrado:
			sprite_node.texture = sprite_cerrado

func _get_variable_manager() -> Node:
	if Engine.has_singleton("VariableManager"): return Engine.get_singleton("VariableManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("VariableManager")
	return null

func _get_inventory_manager() -> Node:
	if Engine.has_singleton("InventarioGlobal"): return Engine.get_singleton("InventarioGlobal")
	if is_inside_tree(): return get_tree().root.get_node_or_null("InventarioGlobal")
	return null

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null
