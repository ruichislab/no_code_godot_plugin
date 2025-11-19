# Archivo: Servicios/SceneManager.gd
extends CanvasLayer

# Configurar como Autoload: "SceneManager"

signal escena_cambiada

@onready var color_rect = ColorRect.new()

func _ready():
	# Configuración visual del fader
	layer = 100 # Asegurar que esté por encima de todo
	color_rect.color = Color(0, 0, 0, 0) # Negro transparente
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE # No bloquear clicks cuando es transparente
	add_child(color_rect)

func cambiar_escena(ruta_escena: String, tiempo_fade: float = 0.5):
	if not ResourceLoader.exists(ruta_escena):
		push_error("SceneManager: No existe la escena " + ruta_escena)
		return
		
	# Bloquear input durante la transición
	get_tree().paused = true
	
	# Fade In (A negro)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # Que funcione en pausa
	tween.tween_property(color_rect, "color:a", 1.0, tiempo_fade)
	await tween.finished
	
	# Cambiar Escena
	var error = get_tree().change_scene_to_file(ruta_escena)
	if error != OK:
		push_error("SceneManager: Error al cambiar escena.")
		
	emit_signal("escena_cambiada")
	
	# Fade Out (A transparente)
	tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color:a", 0.0, tiempo_fade)
	await tween.finished
	
	get_tree().paused = false
