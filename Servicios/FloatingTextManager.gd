# Archivo: addons/no_code_godot_plugin/Servicios/FloatingTextManager.gd
## Gestor de textos flotantes (Daño, Curación, Estado) con Pooling.
##
## **Uso:** Autoload. Muestra números sobre entidades.
## **Características:** Pooling para rendimiento, animaciones "Juicy", colores configurables.
extends Node

# --- CONFIGURACIÓN ---
const POOL_SIZE: int = 50

# Colores predefinidos
const COLOR_DANO: Color = Color(1, 0.3, 0.3)
const COLOR_CRITICO: Color = Color(1, 0.9, 0.2)
const COLOR_CURACION: Color = Color(0.3, 1, 0.5)
const COLOR_INFO: Color = Color.WHITE

# --- ESTADO ---
var _pool_labels: Array[Label] = []
var _contenedor: Node2D

func _ready() -> void:
	# Crear contenedor en CanvasLayer para que siempre esté arriba pero siga coordenadas de mundo?
	# Mejor: Nodo2D directo en la escena para que siga al personaje con la cámara,
	# pero Z-Index alto.
	
	_contenedor = Node2D.new()
	_contenedor.name = "FloatingTextContainer"
	_contenedor.z_index = 100
	add_child(_contenedor)
	
	# Inicializar Pool
	for i in range(POOL_SIZE):
		var lbl = Label.new()
		lbl.visible = false
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		# Configuración de fuente por defecto
		lbl.add_theme_constant_override("outline_size", 4)
		lbl.add_theme_color_override("font_outline_color", Color.BLACK)
		_contenedor.add_child(lbl)
		_pool_labels.append(lbl)
	
	# Conexión automática con EventBus
	if Engine.has_singleton("EventBus"):
		var eb = Engine.get_singleton("EventBus")
		if eb.has_signal("evento_global"):
			eb.evento_global.connect(_on_evento_global)

## Muestra un texto flotante en la posición global dada.
## `tipo`: "dano", "critico", "curacion", "info".
func mostrar_valor(valor: String, posicion_global: Vector2, tipo: String = "info") -> void:
	var label = _obtener_label_libre()
	if not label: return # Pool llena

	# Configurar
	label.text = valor
	label.global_position = posicion_global + Vector2(randf_range(-10, 10), -20)
	label.scale = Vector2.ONE
	label.modulate.a = 1.0
	label.visible = true

	# Estilo según tipo
	var color_final = COLOR_INFO
	var escala_max = 1.0

	match tipo:
		"dano":
			color_final = COLOR_DANO
			escala_max = 1.2
		"critico":
			color_final = COLOR_CRITICO
			escala_max = 1.8
			label.text += "!"
		"curacion":
			color_final = COLOR_CURACION
			label.text = "+" + label.text
		_:
			color_final = COLOR_INFO

	label.modulate = color_final

	# Animación Juicy
	var tween = create_tween().set_parallel(true)

	# Movimiento hacia arriba
	tween.tween_property(label, "global_position:y", label.global_position.y - 60, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	# Escala (Pop)
	if escala_max > 1.0:
		label.scale = Vector2.ZERO
		tween.tween_property(label, "scale", Vector2(escala_max, escala_max), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(label, "scale", Vector2.ONE, 0.2).set_delay(0.3)

	# Desvanecer
	tween.tween_property(label, "modulate:a", 0.0, 0.3).set_delay(0.5)

	# Limpieza (devolver al pool)
	tween.chain().tween_callback(func(): label.visible = false)

func _obtener_label_libre() -> Label:
	for lbl in _pool_labels:
		if not lbl.visible:
			return lbl
	
	# Si no hay libres, podríamos expandir o robar el más viejo.
	# Estrategia simple: Expandir pool
	var nuevo = Label.new()
	nuevo.visible = false
	nuevo.add_theme_constant_override("outline_size", 4)
	nuevo.add_theme_color_override("font_outline_color", Color.BLACK)
	_contenedor.add_child(nuevo)
	_pool_labels.append(nuevo)
	return nuevo

func _on_evento_global(nombre: String, datos: Dictionary) -> void:
	if nombre == "dano_recibido":
		var objetivo = datos.get("objetivo")
		var cantidad = datos.get("cantidad", 0)
		var es_critico = datos.get("es_critico", false)

		if objetivo and is_instance_valid(objetivo) and objetivo is Node2D:
			var tipo = "critico" if es_critico else "dano"
			mostrar_valor(str(int(cantidad)), objetivo.global_position, tipo)

	elif nombre == "curacion_recibida":
		var objetivo = datos.get("objetivo")
		var cantidad = datos.get("cantidad", 0)
		if objetivo and is_instance_valid(objetivo) and objetivo is Node2D:
			mostrar_valor(str(int(cantidad)), objetivo.global_position, "curacion")
