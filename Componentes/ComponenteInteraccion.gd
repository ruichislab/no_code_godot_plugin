# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteInteraccion.gd
## Zona interactiva que detecta al jugador y responde a un input.
##
## **Uso:** Cofres, NPCs, Palancas.
## Debe ser hijo de un Area2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Interaccion
extends Area2D

# --- SEÑALES ---
signal interactuado(jugador: Node)
signal jugador_entro_rango
signal jugador_salio_rango

# --- CONFIGURACIÓN ---
## Texto descriptivo (útil para UI flotante).
@export var texto_interaccion: String = "Interactuar"

## Acción del Input Map requerida para interactuar.
@export var tecla_accion: String = "ui_accept"

## Si es false, ignora intentos de interacción.
@export var es_interactuable: bool = true

## Si es true, interactúa automáticamente al entrar (sin presionar tecla).
@export var auto_interactuar: bool = false

# --- ESTADO ---
var jugador_en_rango: Node = null

func _ready() -> void:
	# Asegurar conexión segura
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	
	# Optimización: No necesitamos ser monitorable, solo monitoring
	monitorable = false
	monitoring = true

func _unhandled_input(event: InputEvent) -> void:
	if not es_interactuable or not jugador_en_rango: return
	if auto_interactuar: return # Ya se manejó
	
	if event.is_action_pressed(tecla_accion):
		interactuar()
		get_viewport().set_input_as_handled()

func interactuar() -> void:
	# print("Interactuando con: " + get_parent().name)
	emit_signal("interactuado", jugador_en_rango)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		jugador_en_rango = body
		emit_signal("jugador_entro_rango")

		if auto_interactuar and es_interactuable:
			interactuar()
		# Opcional: Emitir evento a un UIManager global para mostrar "Presiona E"
		if Engine.has_singleton("UIManager"):
			Engine.get_singleton("UIManager").call("mostrar_prompt", texto_interaccion, self)

func _on_body_exited(body: Node2D) -> void:
	if body == jugador_en_rango:
		jugador_en_rango = null
		emit_signal("jugador_salio_rango")

		if Engine.has_singleton("UIManager"):
			Engine.get_singleton("UIManager").call("ocultar_prompt")

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
