# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd
## Teletransporta al cuerpo que entra a la posición de un nodo destino (dentro de la misma escena).
##
## **Uso:** Atajos, trampas de caída o portales locales.
## **Requisito:** Hijo de Area2D.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Teleporter
extends Area2D

# --- CONFIGURACIÓN ---

## Nodo destino (Marker2D o cualquier Node2D).
@export var destino: Node2D

## Sonido al teletransportar.
@export var sonido_teleport: String = "teleport"

## Resetear velocidad al teletransportar (útil para trampas de caída).
@export var resetear_velocidad: bool = true

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not destino:
		push_warning("RL_Teleporter: No tiene destino asignado.")
		return
		
	if body is Node2D:
		# Sonido
		if sonido_teleport != "" and Engine.has_singleton("AudioManager"):
			Engine.get_singleton("AudioManager").call("play_sfx", sonido_teleport)
			
		# Teletransportar (usar deferred para seguridad física)
		body.global_position = destino.global_position
		
		# Resetear velocidad si es físico
		if resetear_velocidad and "velocity" in body:
			body.velocity = Vector2.ZERO

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not destino:
		warnings.append("Asigna un nodo 'Destino' para saber a dónde teletransportar.")

	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo.")
	return warnings
