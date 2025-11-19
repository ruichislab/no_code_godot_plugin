# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteFootsteps.gd
## Sonidos de pasos automáticos.
##
## **Uso:** Añade este componente al jugador para reproducir pasos al caminar.
## Detecta automáticamente el movimiento.
##
## **Casos de uso:**
## - Pasos del jugador
## - Pasos de enemigos
## - Efectos de terreno
##
## **Requisito:** El padre debe ser CharacterBody2D. Requiere SoundManager.
@icon("res://icon.svg")
class_name ComponenteFootsteps
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var sonidos_pasos: Array[AudioStream]
@export var intervalo: float = 0.35
@export var volumen_db: float = -10.0
@export var pitch_random: float = 0.1

var padre: Node2D
var tiempo_acumulado: float = 0.0
var ultimo_pos: Vector2

func _ready():
	padre = get_parent() as Node2D
	ultimo_pos = padre.global_position

func _process(delta):
	if not padre or sonidos_pasos.is_empty(): return
	
	var velocidad = (padre.global_position - ultimo_pos).length() / delta
	ultimo_pos = padre.global_position
	
	# Umbral de movimiento (aprox 10 px/s)
	if velocidad > 10.0:
		tiempo_acumulado += delta
		if tiempo_acumulado >= intervalo:
			reproducir_paso()
			tiempo_acumulado = 0.0
	else:
		tiempo_acumulado = intervalo # Listo para sonar al empezar a moverse

func reproducir_paso():
	var stream = sonidos_pasos.pick_random()
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx_stream(stream, volumen_db, pitch_random)
		pass
	else:
		# Fallback local
		var player = AudioStreamPlayer2D.new()
		player.stream = stream
		player.volume_db = volumen_db
		player.pitch_scale = 1.0 + randf_range(-pitch_random, pitch_random)
		add_child(player)
		player.play()
		player.play()
		player.finished.connect(player.queue_free)

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null
