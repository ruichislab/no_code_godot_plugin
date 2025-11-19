# Archivo: Servicios/SoundManager.gd
extends Node

# Configurar como Autoload: "SoundManager"

# --- CONFIGURACIÓN ---
var num_canales_sfx: int = 12
var bus_sfx: String = "SFX" # Asegúrate de crear este Bus en la pestaña Audio
var bus_musica: String = "Music"

# --- ESTADO ---
var canales_disponibles: Array[AudioStreamPlayer] = []
var reproductor_musica_1: AudioStreamPlayer
var reproductor_musica_2: AudioStreamPlayer # Para crossfade
var musica_actual: AudioStreamPlayer = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_inicializar_pool_sfx()
	_inicializar_musica()

func _inicializar_pool_sfx():
	for i in range(num_canales_sfx):
		var p = AudioStreamPlayer.new()
		p.bus = bus_sfx
		p.finished.connect(_on_sfx_finished.bind(p))
		add_child(p)
		canales_disponibles.append(p)

func _inicializar_musica():
	reproductor_musica_1 = AudioStreamPlayer.new()
	reproductor_musica_1.bus = bus_musica
	add_child(reproductor_musica_1)
	
	reproductor_musica_2 = AudioStreamPlayer.new()
	reproductor_musica_2.bus = bus_musica
	add_child(reproductor_musica_2)

# --- API PÚBLICA ---

func reproducir_sfx(stream: AudioStream, pitch_random: float = 0.0, volumen_db: float = 0.0):
	if not stream: return
	
	var player = canales_disponibles.pop_back()
	if player:
		player.stream = stream
		player.volume_db = volumen_db
		
		if pitch_random > 0:
			player.pitch_scale = randf_range(1.0 - pitch_random, 1.0 + pitch_random)
		else:
			player.pitch_scale = 1.0
			
		player.play()
	else:
		print("SoundManager: No hay canales SFX disponibles.")

func reproducir_musica(stream: AudioStream, fade_tiempo: float = 1.0):
	if not stream: return
	
	# Si ya está sonando lo mismo, no hacer nada
	if musica_actual and musica_actual.stream == stream and musica_actual.playing:
		return
		
	var nuevo_reproductor = reproductor_musica_1
	if musica_actual == reproductor_musica_1:
		nuevo_reproductor = reproductor_musica_2
		
	nuevo_reproductor.stream = stream
	nuevo_reproductor.volume_db = -80
	nuevo_reproductor.play()
	
	# Crossfade
	var tween = create_tween()
	tween.parallel().tween_property(nuevo_reproductor, "volume_db", 0.0, fade_tiempo)
	
	if musica_actual:
		tween.parallel().tween_property(musica_actual, "volume_db", -80.0, fade_tiempo)
		tween.chain().tween_callback(musica_actual.stop)
		
	musica_actual = nuevo_reproductor

func _on_sfx_finished(player: AudioStreamPlayer):
	canales_disponibles.append(player)
