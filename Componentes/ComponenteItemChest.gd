# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteItemChest.gd
## Contenedor interactuable que da un item y recuerda su estado.
##
## **Uso:** Cofres que se quedan abiertos permanentemente.
## **Requisito:** Debe ser hijo de un Area2D. Usar junto con `RL_Interaccion` o llamar a `interactuar()`.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_ItemChest
extends Area2D

# --- CONFIGURACIÓN ---

## ID único para guardar el estado de este cofre (ej: "nivel1_cofre_secreto").
@export var id_cofre: String = "cofre_01"

## Recurso del item a entregar (Opcional, si usas sistema de inventario).
@export var item_contenido: Resource

## Cantidad de items a entregar.
@export var cantidad: int = 1

## Textura cuando está cerrado.
@export var sprite_cerrado: Texture2D

## Textura cuando está abierto.
@export var sprite_abierto: Texture2D

## Sonido al abrir.
@export var sonido_abrir: String = "chest_open"

var abierto: bool = false
var sprite_node: Sprite2D

func _ready() -> void:
	# Buscar o crear Sprite2D
	sprite_node = get_node_or_null("Sprite2D")
	if not sprite_node:
		sprite_node = Sprite2D.new()
		sprite_node.name = "Sprite2D"
		add_child(sprite_node)

	# Cargar estado persistente (si existe)
	if Engine.has_singleton("VariableManager"):
		var vm = Engine.get_singleton("VariableManager")
		var ya_abierto = vm.call("obtener_valor", "chest_" + id_cofre)
		if ya_abierto == true:
			abierto = true

	_actualizar_visual()

## Método público para abrir el cofre (conectar a RL_Interaccion).
func interactuar(_actor: Node = null) -> void:
	if abierto: return
	abrir()

func abrir() -> void:
	abierto = true
	
	# Guardar estado
	if Engine.has_singleton("VariableManager"):
		Engine.get_singleton("VariableManager").call("set_valor", "chest_" + id_cofre, true)
	
	# Dar item
	if item_contenido and Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")
		if inv.has_method("agregar_item"):
			inv.agregar_item(item_contenido, cantidad)

			# Feedback visual
			if Engine.has_singleton("FloatingTextManager"):
				var nombre = item_contenido.get("nombre") if "nombre" in item_contenido else "Item"
				Engine.get_singleton("FloatingTextManager").call("mostrar_texto", "+%s x%d" % [nombre, cantidad], global_position + Vector2(0, -40), Color.GOLD)
	
	# Sonido
	if sonido_abrir != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_abrir)
		
	_actualizar_visual()

func _actualizar_visual() -> void:
	if not sprite_node: return

	if abierto and sprite_abierto:
		sprite_node.texture = sprite_abierto
	elif not abierto and sprite_cerrado:
		sprite_node.texture = sprite_cerrado

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if id_cofre == "":
		warnings.append("Se recomienda un 'id_cofre' único para guardar el estado.")
	return warnings
