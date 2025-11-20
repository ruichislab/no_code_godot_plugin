# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd
## Item coleccionable que modifica una variable o añade al inventario.
##
## **Uso:** Añade este componente a un Area2D que represente un objeto (moneda, poción).
## Al entrar en contacto con el jugador, se ejecutará la lógica de recolección.
##
## **Requisito:** Debe ser hijo de un Area2D y tener un CollisionShape2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Collectible
extends Area2D

## Nombre de la variable global a modificar (ej: "monedas", "puntos").
@export var nombre_variable: String = "monedas"
## Cantidad a sumar a la variable.
@export var valor_a_sumar: int = 1
## Nombre del efecto de sonido a reproducir (vía AudioManager).
@export var sonido_recoger: String = "coin"
## Si es true, el nodo se elimina tras ser recogido.
@export var eliminar_al_recoger: bool = true
## Opcional: Recurso de item para añadir al inventario (si usas sistema de inventario).
@export var item_inventario: Resource

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		recoger()

## Ejecuta la lógica de recolección.
func recoger() -> void:
	# 1. Modificar Variable Global (si existe el manager)
	if nombre_variable != "":
		if Engine.has_singleton("VariableManager"):
			var vm = Engine.get_singleton("VariableManager")
			if vm.has_method("sumar_valor"):
				vm.sumar_valor(nombre_variable, valor_a_sumar)
				# print("Variable %s aumentada en %d" % [nombre_variable, valor_a_sumar])
	
	# 2. Añadir al Inventario (si hay recurso asignado)
	if item_inventario and Engine.has_singleton("InventarioGlobal"):
		var inv = Engine.get_singleton("InventarioGlobal")
		if inv.has_method("agregar_item"):
			inv.agregar_item(item_inventario, valor_a_sumar)
	
	# 3. Sonido
	if sonido_recoger != "" and Engine.has_singleton("AudioManager"):
		var am = Engine.get_singleton("AudioManager")
		if am.has_method("play_sfx"):
			am.play_sfx(sonido_recoger)

	# 4. Eliminar
	if eliminar_al_recoger:
		queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	# Validar colisión
	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break

	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo para detectar al jugador.")

	return warnings
