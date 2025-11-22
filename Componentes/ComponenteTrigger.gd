# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTrigger.gd
## Área interactiva genérica (Trigger) con visualización de debug.
##
## **Uso:** Ejecuta una lista de Acciones cuando un cuerpo entra.
## **Visualización:** Dibuja un recuadro verde en el editor.
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Trigger
extends Area2D

# --- CONFIGURACIÓN ---
@export var acciones: Array[Resource] = []
@export var una_sola_vez: bool = false
@export_range(0.0, 1.0) var probabilidad: float = 1.0
@export var delay: float = 0.0
@export var solo_jugador: bool = true

# --- ESTADO ---
var _ya_ejecutado: bool = false

func _ready() -> void:
	if not Engine.is_editor_hint():
		if not body_entered.is_connected(_on_body_entered):
			body_entered.connect(_on_body_entered)
	else:
		# Optimización Editor: Redibujar solo si cambian hijos
		child_entered_tree.connect(func(_x): queue_redraw())
		child_exiting_tree.connect(func(_x): queue_redraw())

func _on_body_entered(body: Node2D) -> void:
	if solo_jugador:
		if body.is_in_group("jugador") or body.name == "Jugador":
			activar(body)
	else:
		activar(body)

func activar(actor: Node = null) -> void:
	if _ya_ejecutado and una_sola_vez: return
	if probabilidad < 1.0 and randf() > probabilidad: return

	if una_sola_vez: _ya_ejecutado = true

	if delay > 0:
		await get_tree().create_timer(delay).timeout
		
	for accion in acciones:
		if accion and accion.has_method("ejecutar"):
			accion.ejecutar(actor)

# --- DEBUG VISUAL ---
# Eliminado _process en editor para evitar redraw constante.
# Se usa señales de cambio de hijos o setget si fuera necesario.

func _draw() -> void:
	if not Engine.is_editor_hint(): return

	var color = ProjectSettings.get_setting("ruichislab/colores/trigger", Color.GREEN)

	for child in get_children():
		if child is CollisionShape2D and child.shape:
			var shape = child.shape
			if shape is RectangleShape2D:
				draw_rect(child.shape.get_rect(), color, false, 2.0)
				var relleno = color
				relleno.a = 0.2
				draw_rect(child.shape.get_rect(), relleno, true)
			elif shape is CircleShape2D:
				draw_circle(child.position, shape.radius, Color(color.r, color.g, color.b, 0.2))
				draw_arc(child.position, shape.radius, 0, TAU, 32, color, 2.0)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if acciones.is_empty():
		warnings.append("Sin acciones asignadas.")
	return warnings
