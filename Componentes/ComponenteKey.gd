# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteKey.gd
## Objeto que activa una variable global ("llave") al ser recogido.
##
## **Uso:** Llaves de colores, tarjetas de acceso.
## **Requisito:** Hijo de Area2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Key
extends Area2D

# --- CONFIGURACIÓN ---

## Nombre de la variable a activar (ej: "llave_roja").
@export var id_llave: String = "llave_roja"

## Sonido al recoger.
@export var sonido: String = "key_pickup"

## Efecto visual al recoger (opcional, PackedScene de partículas).
@export var efecto_visual: PackedScene

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		recoger()

func recoger() -> void:
	# 1. Activar Variable
	if Engine.has_singleton("VariableManager"):
		var vm = Engine.get_singleton("VariableManager")
		if vm.has_method("set_valor"):
			vm.set_valor(id_llave, true)
			# print("Llave recogida: " + id_llave)

	# 2. Sonido
	if sonido != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido)

	# 3. Efecto Visual (instanciar antes de borrar)
	if efecto_visual:
		var fx = efecto_visual.instantiate()
		fx.global_position = global_position
		get_tree().current_scene.add_child(fx)
		
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo.")
	return warnings
