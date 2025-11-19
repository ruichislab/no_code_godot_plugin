# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSoundArea.gd
## Zona con música/sonido ambiental.
##
## **Uso:** Añade este componente para crear zonas con música específica.
## Cambia la música al entrar/salir del área.
##
## **Casos de uso:**
## - Música de combate
## - Música de pueblo
## - Sonidos ambientales
## - Zonas de peligro
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere SoundManager.
@icon("res://icon.svg")
class_name ComponenteSoundArea
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var stream_audio: AudioStream
@export var bus: String = "Music"
@export var transicion_segundos: float = 2.0
@export var volumen_db: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		var sm = _get_sound_manager()
		if sm:
			if sm.has_method("play_music"):
				sm.play_music(stream_audio, volumen_db)
			elif sm.has_method("reproducir_musica"):
				sm.reproducir_musica(stream_audio, volumen_db)
		else:
			print("SoundArea: SoundManager no encontrado. Reproduciendo localmente.")
			# Fallback simple si no hay SoundManager
			var player = AudioStreamPlayer.new()
			player.stream = stream_audio
			player.bus = bus
			player.volume_db = volumen_db
			add_child(player)
			player.play()
