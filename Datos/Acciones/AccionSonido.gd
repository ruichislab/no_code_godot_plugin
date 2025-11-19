# Archivo: Datos/Acciones/AccionSonido.gd
class_name AccionSonido
extends GameAction

@export var sonido: AudioStream
@export var volumen_db: float = 0.0
@export var pitch_random: float = 0.1

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	return null

func ejecutar(nodo_origen: Node = null):
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx_stream"):
			sm.play_sfx_stream(sonido, volumen_db, pitch_random)
		elif sm.has_method("reproducir_sonido"):
			sm.reproducir_sonido(sonido, linear_to_db(volumen_db))
