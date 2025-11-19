# Archivo: Datos/Acciones/AccionSonido.gd
class_name AccionSonido
extends GameAction

@export var sonido: AudioStream
@export var volumen_db: float = 0.0
@export var pitch_random: float = 0.1

func ejecutar(nodo_origen: Node = null):
	if SoundManager:
		SoundManager.reproducir_sfx(sonido, pitch_random, volumen_db)
