# Archivo: Servicios/GameManager.gd
extends Node

# --- SINGLETON ---
# Configurar como Autoload en Project Settings -> Globals -> GameManager

# --- SEÑALES ---
signal juego_pausado(esta_pausado: bool)
signal game_over

# --- REFERENCIAS GLOBALES ---
var jugador: CharacterBody2D
var interfaz_usuario: CanvasLayer

# --- ESTADO DEL JUEGO ---
var esta_en_pausa: bool = false

# --- AUTOGUARDADO ---
@export_group("Configuración de Autoguardado")
@export_range(30.0, 600.0, 1.0, "suffix:segundos") var tiempo_autoguardado: float = 300.0 # 5 minutos
var temporizador_autoguardado: Timer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # Este nodo siempre corre, incluso en pausa
	
	# Configurar Autoguardado
	temporizador_autoguardado = Timer.new()
	temporizador_autoguardado.wait_time = tiempo_autoguardado
	temporizador_autoguardado.autostart = true
	temporizador_autoguardado.one_shot = false
	temporizador_autoguardado.timeout.connect(_on_autoguardado)
	add_child(temporizador_autoguardado)

func _on_autoguardado():
	if not esta_en_pausa: # Evitar guardar durante menús si se prefiere
		print("Autoguardando...")
		SistemaGuardado.guardar_juego()

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Por defecto 'Esc'
		alternar_pausa()

func registrar_jugador(nodo_jugador: CharacterBody2D):
	jugador = nodo_jugador
	print("GameManager: Jugador registrado.")

func alternar_pausa():
	esta_en_pausa = !esta_en_pausa
	get_tree().paused = esta_en_pausa
	emit_signal("juego_pausado", esta_en_pausa)

func activar_game_over():
	emit_signal("game_over")
	get_tree().paused = true
	# Aquí podrías mostrar la pantalla de Game Over
