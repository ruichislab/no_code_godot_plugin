# Archivo: Servicios/DebugConsole.gd
extends CanvasLayer

# Configurar como Autoload: "DebugConsole"
# Consola de desarrollador para ejecutar comandos en tiempo de juego.
# Tecla de acceso: 'º' (o la que configures en _input)

var input_line: LineEdit
var output_log: RichTextLabel
var contenedor: VBoxContainer
var historial: Array[String] = []
var historial_index: int = -1

var comandos: Dictionary = {}

func _ready():
	layer = 128 # Muy por encima
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS # Funciona en pausa
	
	_crear_ui()
	_registrar_comandos_base()

func _crear_ui():
	contenedor = VBoxContainer.new()
	contenedor.set_anchors_preset(Control.PRESET_TOP_WIDE)
	contenedor.size.y = 300
	
	# Fondo semitransparente
	var bg = ColorRect.new()
	bg.color = Color(0, 0, 0, 0.8)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	contenedor.add_child(bg)
	
	output_log = RichTextLabel.new()
	output_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output_log.scroll_following = true
	contenedor.add_child(output_log)
	
	input_line = LineEdit.new()
	input_line.text_submitted.connect(_on_text_submitted)
	contenedor.add_child(input_line)
	
	add_child(contenedor)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_QUOTELEFT: # Tecla º
		toggle()

func toggle():
	visible = !visible
	if visible:
		input_line.grab_focus()
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_text_submitted(texto: String):
	input_line.clear()
	log_msg("> " + texto, Color.GRAY)
	historial.append(texto)
	historial_index = historial.size()
	
	var partes = texto.split(" ", false)
	if partes.size() == 0: return
	
	var cmd = partes[0].to_lower()
	var args = partes.slice(1)
	
	if comandos.has(cmd):
		comandos[cmd].call(args)
	else:
		log_msg("Comando desconocido: " + cmd, Color.RED)

func registrar_comando(nombre: String, funcion: Callable):
	comandos[nombre.to_lower()] = funcion

func log_msg(texto: String, color: Color = Color.WHITE):
	output_log.push_color(color)
	output_log.add_text(texto + "\n")
	output_log.pop()

# --- COMANDOS BASE ---

func _registrar_comandos_base():
	registrar_comando("help", func(args):
		log_msg("Comandos disponibles: " + ", ".join(comandos.keys()), Color.GREEN)
	)
	
	registrar_comando("heal", func(args):
		var gm = _get_game_manager()
		if gm and gm.jugador and gm.jugador.has_node("Estadisticas"):
			gm.jugador.get_node("Estadisticas").curar(1000)
			log_msg("Jugador curado.", Color.GREEN)
	)
	
	registrar_comando("god", func(args):
		var gm = _get_game_manager()
		if gm and gm.jugador and gm.jugador.has_node("Estadisticas"):
			var stats = gm.jugador.get_node("Estadisticas")
			# Implementar lógica de invulnerabilidad en Estadisticas
			log_msg("Modo Dios no implementado completamente.", Color.YELLOW)
	)
	
	registrar_comando("give", func(args):
		if args.size() < 1:
			log_msg("Uso: give <id_item> [cantidad]", Color.RED)
			return
		var id = args[0]
		var cantidad = int(args[1]) if args.size() > 1 else 1
		var inv = _get_inventory_manager()
		if inv:
			inv.anadir_objeto(id, cantidad)
			log_msg("Añadido %d de %s" % [cantidad, id], Color.GREEN)
	)

func _get_game_manager() -> Node:
	if Engine.has_singleton("GameManager"): return Engine.get_singleton("GameManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GameManager")
	return null

func _get_inventory_manager() -> Node:
	if Engine.has_singleton("InventarioGlobal"): return Engine.get_singleton("InventarioGlobal")
	if is_inside_tree(): return get_tree().root.get_node_or_null("InventarioGlobal")
	return null
