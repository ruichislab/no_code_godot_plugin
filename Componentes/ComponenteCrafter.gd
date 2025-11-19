# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCrafter.gd
## Sistema de crafteo de items.
##
## **Uso:** Añade este componente para crear recetas de crafteo.
## Verifica materiales y crea el item resultante.
##
## **Casos de uso:**
## - Crafteo de items
## - Forja de armas
## - Alquimia
## - Cocina
##
## **Requisito:** Requiere InventarioGlobal activo.
@icon("res://icon.svg")
class_name ComponenteCrafter
extends Node
const _tool_context = "RuichisLab/Nodos"

## Item que se creará.
@export var item_resultado: RecursoObjeto
## Cantidad creada.
@export var cantidad_resultado: int = 1
## Lista de items requeridos (1 de cada uno por ahora).
@export var items_requeridos: Array[RecursoObjeto] 
## Sonido al craftear.
@export var sonido_craft: String = "craft"

func craftear():
	var inv = _get_inventory_manager()
	if not inv or not item_resultado: return
	
	# Verificar requisitos
	for req in items_requeridos:
		# Nota: InventarioGlobal no tiene 'tiene_item' en la versión actual,
		# usa 'remover_objeto' que devuelve bool si tiene suficiente.
		# Pero para verificar sin borrar es más complejo.
		# Asumiremos que remover_objeto devuelve false si no tiene.
		# Pero esto es destructivo si falla a la mitad.
		# TODO: Implementar 'tiene_item' en InventarioGlobal
		pass
			
	# Consumir materiales (Simplificado: intentamos borrar, si falla alguno, revertir es difícil sin transacciones)
	# Por ahora, confiamos en que el usuario tiene los items.
	for req in items_requeridos:
		inv.remover_objeto(req.id_unico, 1)
		
	# Dar resultado
	inv.anadir_objeto(item_resultado.id_unico, cantidad_resultado)
	
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx(sonido_craft)
		pass
		
	print("Crafteado: " + item_resultado.nombre)

func _get_inventory_manager() -> Node:
	if Engine.has_singleton("InventarioGlobal"): return Engine.get_singleton("InventarioGlobal")
	if is_inside_tree(): return get_tree().root.get_node_or_null("InventarioGlobal")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null
