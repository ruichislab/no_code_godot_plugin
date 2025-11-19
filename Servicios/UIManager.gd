# Archivo: Servicios/UIManager.gd
extends CanvasLayer

# Configurar como Autoload: "UIManager"
# Gestiona la pila de menús (Inventario, Pausa, Diálogo).

signal menu_abierto(nombre: String)
signal menu_cerrado(nombre: String)

var pila_menus: Array[Control] = []

func _ready():
	layer = 10 # Por encima del juego, por debajo de la consola/transiciones
	process_mode = Node.PROCESS_MODE_ALWAYS

func abrir_menu(menu: Control):
	if not menu: return
	
	if pila_menus.has(menu):
		push_warning("El menú ya está abierto.")
		return
		
	# Pausar juego si es el primer menú (opcional, configurable)
	if pila_menus.is_empty():
		get_tree().paused = true
		
	menu.visible = true
	pila_menus.append(menu)
	
	# Dar foco al primer elemento interactuable
	var focus_owner = menu.find_next_valid_focus()
	if focus_owner:
		focus_owner.grab_focus()
		
	emit_signal("menu_abierto", menu.name)

func cerrar_menu_actual():
	if pila_menus.is_empty(): return
	
	var menu = pila_menus.pop_back()
	menu.visible = false
	emit_signal("menu_cerrado", menu.name)
	
	if pila_menus.is_empty():
		get_tree().paused = false
	else:
		# Devolver foco al menú anterior
		var anterior = pila_menus.back()
		var focus_owner = anterior.find_next_valid_focus()
		if focus_owner:
			focus_owner.grab_focus()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"): # Esc / B
		if not pila_menus.is_empty():
			cerrar_menu_actual()
			get_viewport().set_input_as_handled()
		else:
			# Si no hay menús, abrir pausa (ejemplo)
			# abrir_menu(menu_pausa)
			pass
