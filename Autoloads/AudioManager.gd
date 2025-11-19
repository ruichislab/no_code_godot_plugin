# Archivo: addons/no_code_godot_plugin/Autoloads/AudioManager.gd
## Manager global para audio.
##
## **Uso:** Autoload automático. Úsalo con `AudioManager.reproducir_sonido()`.
##
## **Funciones:**
## - Reproducir efectos de sonido
## - Reproducir/detener música
## - Control de volumen
## - Sistema de pooling para sonidos

extends Node

const MAX_SOUND_PLAYERS = 16

var music_player: AudioStreamPlayer
var sound_players: Array[AudioStreamPlayer] = []
var current_player_index: int = 0

var master_volume: float = 1.0
var music_volume: float = 0.7
var sfx_volume: float = 1.0

func _ready():
	# Crear reproductor de música
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Crear pool de reproductores de efectos
	for i in MAX_SOUND_PLAYERS:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		player.finished.connect(_on_sound_finished.bind(player))
		add_child(player)
		sound_players.append(player)
	
	print("AudioManager: Inicializado con ", MAX_SOUND_PLAYERS, " canales de audio")

## Reproduce un efecto de sonido.
func reproducir_sonido(stream: AudioStream, volumen: float = 1.0):
	if not stream:
		push_warning("AudioManager: No se proporcionó un AudioStream")
		return
	
	# Buscar reproductor disponible
	for player in sound_players:
		if not player.playing:
			player.stream = stream
			player.volume_db = linear_to_db(volumen * sfx_volume)
			player.play()
			return
	
	# Si todos están ocupados, usa el índice rotativo
	var player = sound_players[current_player_index]
	player.stream = stream
	player.volume_db = linear_to_db(volumen * sfx_volume)
	player.play()
	current_player_index = (current_player_index + 1) % MAX_SOUND_PLAYERS

## Reproduce música de fondo.
func reproducir_musica(stream: AudioStream, volumen: float = 1.0):
	if not stream:
		push_warning("AudioManager: No se proporcionó música")
		return
	
	music_player.stream = stream
	music_player.volume_db = linear_to_db(volumen * music_volume)
	music_player.play()
	print("AudioManager: Reproduciendo música")

## Detiene la música.
func detener_musica():
	music_player.stop()
	print("AudioManager: Música detenida")

## Cambia el volumen de la música.
func set_music_volume(vol: float):
	music_volume = clamp(vol, 0.0, 1.0)
	music_player.volume_db = linear_to_db(music_volume)

## Cambia el volumen de los efectos.
func set_sfx_volume(vol: float):
	sfx_volume = clamp(vol, 0.0, 1.0)

func _on_sound_finished(player: AudioStreamPlayer):
	# El player vuelve al pool automáticamente
	pass
