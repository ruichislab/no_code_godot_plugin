# Archivo: addons/no_code_godot_plugin/Autoloads/AudioManager.gd
## Manager global de audio profesional.
##
## **Características:**
## - Pooling dinámico de reproductores SFX.
## - Variación automática de tono y volumen.
## - Música con transición suave (Crossfade).
## - Buses de mezcla separados.
extends Node

# --- CONFIGURACIÓN ---
const MAX_REPRODUCTORES_SFX: int = 32
const BUS_MAESTRO: String = "Master"
const BUS_MUSICA: String = "Music"
const BUS_SFX: String = "SFX"

# --- ESTADO ---
var _reproductor_musica_1: AudioStreamPlayer
var _reproductor_musica_2: AudioStreamPlayer
var _reproductor_activo: AudioStreamPlayer = null

var _pool_sfx: Array[AudioStreamPlayer] = []
var _indice_sfx: int = 0

var _interpolacion_musica: Tween

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	_crear_buses_si_no_existen()
	
	# Inicializar reproductores de música
	_reproductor_musica_1 = AudioStreamPlayer.new()
	_reproductor_musica_1.bus = BUS_MUSICA
	add_child(_reproductor_musica_1)
	
	_reproductor_musica_2 = AudioStreamPlayer.new()
	_reproductor_musica_2.bus = BUS_MUSICA
	add_child(_reproductor_musica_2)

	# Inicializar pool de SFX
	for i in range(MAX_REPRODUCTORES_SFX):
		var p = AudioStreamPlayer.new()
		p.bus = BUS_SFX
		add_child(p)
		_pool_sfx.append(p)

	print("AudioManager: Inicializado (32 canales SFX, Transición Música).")

## Reproduce un efecto de sonido con variación opcional.
func reproducir_sfx(audio: AudioStream, vol_db: float = 0.0, tono: float = 1.0, variacion_tono: float = 0.1) -> void:
	if not audio: return

	var reproductor = _obtener_reproductor_libre()
	
	# Variación aleatoria
	var tono_final = tono + randf_range(-variacion_tono, variacion_tono)
	var vol_final = vol_db + randf_range(-2.0, 0.0)
	
	reproductor.stream = audio
	reproductor.volume_db = vol_final
	reproductor.pitch_scale = max(0.1, tono_final)
	reproductor.play()

## Reproduce música con transición suave.
func reproducir_musica(audio: AudioStream, tiempo_transicion: float = 2.0, vol_db: float = 0.0) -> void:
	if not audio: return

	if _reproductor_activo and _reproductor_activo.stream == audio and _reproductor_activo.playing:
		return
	
	var nuevo = _reproductor_musica_1 if _reproductor_activo != _reproductor_musica_1 else _reproductor_musica_2
	var viejo = _reproductor_activo

	# Configurar nuevo
	nuevo.stream = audio
	nuevo.volume_db = -80.0 # Empezar mudo
	nuevo.play()

	_reproductor_activo = nuevo

	# Animar
	if _interpolacion_musica: _interpolacion_musica.kill()
	_interpolacion_musica = create_tween().set_parallel(true)

	# Fade In Nuevo
	_interpolacion_musica.tween_property(nuevo, "volume_db", vol_db, tiempo_transicion).set_trans(Tween.TRANS_SINE)

	# Fade Out Viejo
	if viejo and viejo.playing:
		var t = _interpolacion_musica.tween_property(viejo, "volume_db", -80.0, tiempo_transicion)
		t.finished.connect(viejo.stop)

## Detiene la música con fade out.
func detener_musica(tiempo_fade: float = 2.0) -> void:
	if _reproductor_activo and _reproductor_activo.playing:
		if _interpolacion_musica: _interpolacion_musica.kill()
		_interpolacion_musica = create_tween()
		var t = _interpolacion_musica.tween_property(_reproductor_activo, "volume_db", -80.0, tiempo_fade)
		t.finished.connect(_reproductor_activo.stop)

# --- INTERNO ---

func _obtener_reproductor_libre() -> AudioStreamPlayer:
	var reproductor = _pool_sfx[_indice_sfx]
	_indice_sfx = (_indice_sfx + 1) % MAX_REPRODUCTORES_SFX
	return reproductor

func _crear_buses_si_no_existen() -> void:
	if AudioServer.get_bus_index(BUS_MUSICA) == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, BUS_MUSICA)
		AudioServer.set_bus_send(AudioServer.get_bus_index(BUS_MUSICA), BUS_MAESTRO)

	if AudioServer.get_bus_index(BUS_SFX) == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, BUS_SFX)
		AudioServer.set_bus_send(AudioServer.get_bus_index(BUS_SFX), BUS_MAESTRO)
