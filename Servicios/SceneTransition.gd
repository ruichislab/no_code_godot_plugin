# Archivo: addons/no_code_godot_plugin/Servicios/SceneTransition.gd
## Capa visual para transiciones entre escenas (Autoload interno o instanciado por GameManager).
extends CanvasLayer

signal transicion_mitad_completada
signal transicion_terminada

@onready var color_rect: ColorRect = ColorRect.new()
var _tween: Tween

func _ready() -> void:
	layer = 100 # Muy alto para estar encima de todo
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	color_rect.color = Color.BLACK
	color_rect.modulate.a = 0.0
	add_child(color_rect)

## Inicia una transición de Fundido (Fade).
## `duracion`: Tiempo total (mitad fade out, mitad fade in).
func transicion_fade(duracion: float = 1.0) -> void:
	if _tween: _tween.kill()
	_tween = create_tween()

	# Bloquear input durante transición
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	# Fase 1: Oscurecer
	_tween.tween_property(color_rect, "modulate:a", 1.0, duracion / 2.0).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(func(): emit_signal("transicion_mitad_completada"))

	# Fase 2: Aclarar (esperar señal externa o continuar automáticamente?
	# GameManager controlará el "hold" si hay carga asíncrona.
	# Aquí asumimos flujo continuo simple, pero expondremos métodos manuales.)

func finalizar_transicion(duracion_fade_in: float = 0.5) -> void:
	if _tween: _tween.kill()
	_tween = create_tween()

	_tween.tween_property(color_rect, "modulate:a", 0.0, duracion_fade_in).set_trans(Tween.TRANS_SINE)
	_tween.tween_callback(func():
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		emit_signal("transicion_terminada")
	)
