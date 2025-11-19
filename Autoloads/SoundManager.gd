# Archivo: addons/no_code_godot_plugin/Autoloads/SoundManager.gd
# Compatibilidad simple: proporciona la API esperada `SoundManager.play_sfx(...)`
# Internamente intenta delegar en `AudioManager` si existe, o reproducir el AudioStream directamente.

extends Node

func _get_audio_manager():
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		var n = get_tree().root.get_node_or_null("AudioManager")
		if n:
			return n
	return null

# Reproduce un efecto. `id_or_stream` puede ser un AudioStream o un String clave/path.
func play_sfx(id_or_stream, volumen: float = 1.0):
	var am = _get_audio_manager()
	# Si ya es un AudioStream, delega a AudioManager o reproduce localmente.
	if typeof(id_or_stream) == TYPE_OBJECT:
		if am and am.has_method("reproducir_sonido"):
			am.reproducir_sonido(id_or_stream, volumen)
			return
		# Fallback: crear un player temporal
		var p = AudioStreamPlayer.new()
		p.stream = id_or_stream
		add_child(p)
		p.play()
		return

	# Si es string, intentar delegar a AudioManager con recursos conocidos
	var key = String(id_or_stream)
	# Si AudioManager tiene una función de mapeo (no incluida por defecto), usarla
	if am and am.has_method("play_sfx"):
		# Si el AudioManager personalizado define play_sfx por nombre
		am.play_sfx(key)
		return

	# Intentar cargar archivos comunes en res://assets/sfx/<key>.(ogg|wav)
	var candidates = ["res://assets/sfx/%s.ogg" % key, "res://assets/sfx/%s.wav" % key, key]
	for path in candidates:
		# ResourceLoader.exists no existe en GDScript en todas las versiones, usar safe load
		var ok = false
		var stream = null
		# Intentar cargar y comprobar
		if path != "":
			# try load
			var res = null
			var _err = null
			res = load(path)
			if typeof(res) == TYPE_OBJECT and res is AudioStream:
				stream = res
				ok = true
			# si se pasó un path que no existe, load devuelve null
		if ok and stream:
			if am and am.has_method("reproducir_sonido"):
				am.reproducir_sonido(stream, volumen)
				return
			# Fallback a reproductor temporal
			var p2 = AudioStreamPlayer.new()
			p2.stream = stream
			add_child(p2)
			p2.play()
			return

	push_warning("SoundManager: No se encontró recurso de sonido para '%s' y AudioManager no proporcionó un handler." % key)

# Variantes usadas en algunos componentes
func play_sfx_stream(stream: AudioStream, volumen: float = 1.0, pitch_random: float = 0.0):
	if stream == null:
		return
	var am = _get_audio_manager()
	if am and am.has_method("reproducir_sonido"):
		am.reproducir_sonido(stream, volumen)
		return
	var p = AudioStreamPlayer.new()
	p.stream = stream
	p.volume_db = linear_to_db(volumen)
	if pitch_random != 0.0 and p.has_method("set_pitch_scale"):
		p.pitch_scale = 1.0 + randf() * pitch_random
	add_child(p)
	p.play()

# Helpers mínimos para compatibilidad con APIs que algunos usuarios esperan
func play_music(stream: AudioStream, volumen: float = 1.0):
	var am = _get_audio_manager()
	if am and am.has_method("reproducir_musica"):
		am.reproducir_musica(stream, volumen)
		return
	push_warning("SoundManager: No hay AudioManager con método reproducir_musica")

func stop_music():
	var am = _get_audio_manager()
	if am and am.has_method("detener_musica"):
		am.detener_musica()
		return

```