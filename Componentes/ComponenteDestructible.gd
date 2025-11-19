# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDestructible.gd
## Objeto que puede ser destruido.
##
## **Uso:** Añade este componente a objetos que pueden romperse.
## Tiene vida propia independiente del sistema de Estadisticas.
##
## **Casos de uso:**
## - Barriles
## - Cajas
## - Jarrones
## - Paredes destructibles
## - Cristales
##
## **Nota:** Reproduce efectos de sonido y partículas al destruirse.
@icon("res://icon.svg")
class_name ComponenteDestructible
extends Node
const _tool_context = "RuichisLab/Nodos"

## Salud total antes de romperse.
@export var salud_maxima: float = 1.0
## Sonido al recibir daño.
@export var sonido_impacto: String = "hit_wood"
## Sonido al romperse.
@export var sonido_destruccion: String = "break_wood"
## Partículas a instanciar al romperse.
@export var particulas_destruccion: PackedScene

var salud_actual: float
var padre: Node2D

func _ready():
	padre = get_parent() as Node2D
	salud_actual = salud_maxima
	
	# Buscar hurtbox para conectar señal
	var hurtbox = padre.get_node_or_null("Hurtbox") # Nombre común
	if not hurtbox:
		# Buscar por tipo
		for child in padre.get_children():
			if child is ComponenteHurtbox:
				hurtbox = child
				break
				
	if hurtbox:
		hurtbox.dano_recibido.connect(_on_dano_recibido)
	else:
		push_warning("NC_Destructible: No se encontró NC_Hurtbox en el padre.")

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _on_dano_recibido(cantidad, origen):
	salud_actual -= cantidad
	
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido_impacto)
		elif sm.has_method("reproducir_sonido") and typeof(sonido_impacto) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido_impacto)
		
	# Feedback visual (flash blanco)
	if padre.modulate == Color.WHITE:
		var tween = create_tween()
		tween.tween_property(padre, "modulate", Color.RED, 0.05)
		tween.tween_property(padre, "modulate", Color.WHITE, 0.05)
	
	if salud_actual <= 0:
		destruir()

func destruir():
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx(sonido_destruccion)
		elif sm.has_method("reproducir_sonido") and typeof(sonido_destruccion) == TYPE_OBJECT:
			sm.reproducir_sonido(sonido_destruccion)
		
	if particulas_destruccion:
		var p = particulas_destruccion.instantiate()
		p.global_position = padre.global_position
		get_tree().current_scene.add_child(p)
		
	# Notificar muerte para LootDropper
	if padre.has_signal("muerto"):
		padre.emit_signal("muerto")
	elif EventBus:
		EventBus.emitir_muerte(padre)
		
	padre.queue_free()
