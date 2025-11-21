# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd
## Zona de Daño con visualización de debug.
##
## **Visualización:** Dibuja un recuadro rojo con trama de peligro.
@tool
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_DamageZone
extends Area2D

# --- CONFIGURACIÓN ---
@export var dano_por_segundo: float = 10.0
@export var intervalo: float = 0.5

# --- ESTADO ---
var objetivos: Array[Area2D] = []
var timer: float = 0.0

func _ready() -> void:
	if not Engine.is_editor_hint():
		if not area_entered.is_connected(_on_area_entered):
			area_entered.connect(_on_area_entered)
		if not area_exited.is_connected(_on_area_exited):
			area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		return

	if objetivos.is_empty(): return
	timer -= delta
	if timer <= 0:
		timer = intervalo
		_aplicar_dano()

func _aplicar_dano() -> void:
	var dano_tick = dano_por_segundo * intervalo
	var activos = objetivos.duplicate()
	for hb in activos:
		if is_instance_valid(hb) and hb.has_method("recibir_dano"):
			hb.recibir_dano(dano_tick, self)
		else:
			objetivos.erase(hb)

func _on_area_entered(area: Area2D) -> void:
	if (area is RL_Hurtbox or area.has_method("recibir_dano")) and not area in objetivos:
		objetivos.append(area)

func _on_area_exited(area: Area2D) -> void:
	objetivos.erase(area)

# --- DEBUG VISUAL ---
func _draw() -> void:
	if not Engine.is_editor_hint(): return

	var color = ProjectSettings.get_setting("ruichislab/colores/dano", Color.RED)

	for child in get_children():
		if child is CollisionShape2D and child.shape:
			var shape = child.shape
			if shape is RectangleShape2D:
				var rect = shape.get_rect()
				draw_rect(rect, color, false, 3.0)
				# Dibujar rayas diagonales
				_dibujar_trama(rect, color)
			elif shape is CircleShape2D:
				draw_circle(child.position, shape.radius, Color(color.r, color.g, color.b, 0.2))
				draw_arc(child.position, shape.radius, 0, TAU, 32, color, 3.0)

func _dibujar_trama(rect: Rect2, color: Color) -> void:
	var step = 10.0
	var alpha_col = color
	alpha_col.a = 0.5
	for i in range(0, int(rect.size.x + rect.size.y), int(step)):
		var start = Vector2(rect.position.x + i, rect.position.y)
		var end = Vector2(rect.position.x + i - rect.size.y, rect.position.y + rect.size.y)
		# Clampear (simplificado, solo visual)
		draw_line(start, end, alpha_col, 1.0)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if get_child_count() == 0: warnings.append("Falta CollisionShape2D.")
	return warnings
