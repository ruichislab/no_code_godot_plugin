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

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		if SoundManager:
			SoundManager.play_music(stream_audio, transicion_segundos, bus)
		else:
			print("SoundArea: SoundManager no encontrado. Reproduciendo localmente.")
			# Fallback simple si no hay SoundManager
			var player = AudioStreamPlayer.new()
			player.stream = stream_audio
			player.bus = bus
			player.volume_db = volumen_db
			add_child(player)
			player.play()
