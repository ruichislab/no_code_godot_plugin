# Archivo: Servicios/FloatingTextManager.gd
extends Node

# Configurar como Autoload: "FloatingTextManager"

func _ready():
	# Nos conectamos al bus de eventos para reaccionar automáticamente al daño
	# Esto significa que NO necesitamos modificar cada script de enemigo.
	if get_tree().root.has_node("EventBus"):
		EventBus.entidad_danada.connect(_on_entidad_danada)

func _on_entidad_danada(entidad: Node, cantidad: float, es_critico: bool):
	if entidad is Node2D:
		var color = Color.YELLOW if es_critico else Color.WHITE
		mostrar_texto(str(round(cantidad)), entidad.global_position, color)

func mostrar_texto(texto: String, posicion: Vector2, color: Color = Color.WHITE, duracion: float = 0.8):
	var label = Label.new()
	label.text = texto
	label.global_position = posicion + Vector2(randf_range(-10, 10), -20)
	label.z_index = 100 # Asegurar que se vea encima de todo
	
	# Estilo
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", 20 if color == Color.YELLOW else 14)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	
	get_tree().current_scene.add_child(label)
	
	# Animación
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "global_position:y", label.global_position.y - 50, duracion).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(label, "modulate:a", 0.0, duracion).set_ease(Tween.EASE_IN)
	
	# Limpieza
	tween.chain().tween_callback(label.queue_free)
