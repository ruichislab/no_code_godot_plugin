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
	if not InventarioGlobal or not item_resultado: return
	
	# Verificar requisitos
	for req in items_requeridos:
		if not InventarioGlobal.tiene_item(req.id):
			print("Falta material: " + req.nombre)
			return
			
	# Consumir materiales
	for req in items_requeridos:
		InventarioGlobal.remover_objeto(req.id_unico, 1)
		
	# Dar resultado
	InventarioGlobal.agregar_objeto(item_resultado, cantidad_resultado)
	
	if SoundManager:
		SoundManager.play_sfx(sonido_craft)
		
	print("Crafteado: " + item_resultado.nombre)
