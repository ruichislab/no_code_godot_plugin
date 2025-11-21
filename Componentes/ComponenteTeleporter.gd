# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd
## Teletransportador local con línea visual de conexión.
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Teleporter
extends Area2D

# --- CONFIGURACIÓN ---
@export var destino: Node2D:
	set(val):
		destino = val
		queue_redraw()

@export var sonido_teleport: String = "teleport"
@export var resetear_velocidad: bool = true

func _ready() -> void:
	if not Engine.is_editor_hint():
		if not body_entered.is_connected(_on_body_entered):
			body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and destino:
		queue_redraw() # Actualizar línea si el destino se mueve

func _on_body_entered(body: Node2D) -> void:
	if not destino: return

	if body is Node2D:
		if sonido_teleport != "" and Engine.has_singleton("AudioManager"):
			Engine.get_singleton("AudioManager").call("reproducir_sfx", sonido_teleport)
			
		body.global_position = destino.global_position
		
		if resetear_velocidad and "velocity" in body:
			body.velocity = Vector2.ZERO

# --- DEBUG VISUAL ---
func _draw() -> void:
	if not Engine.is_editor_hint(): return

	var color = Color.CYAN

	# Dibujar icono local
	draw_circle(Vector2.ZERO, 10.0, color)
	draw_circle(Vector2.ZERO, 5.0, Color.WHITE)

	# Dibujar conexión
	if destino:
		var pos_local_destino = to_local(destino.global_position)
		draw_line(Vector2.ZERO, pos_local_destino, color, 2.0, true)
		# Flecha
		var dir = pos_local_destino.normalized()
		draw_line(pos_local_destino, pos_local_destino - dir * 10 + dir.rotated(1.0) * 10, color, 2.0)
		draw_line(pos_local_destino, pos_local_destino - dir * 10 + dir.rotated(-1.0) * 10, color, 2.0)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not destino: warnings.append("Falta asignar destino.")
	return warnings
