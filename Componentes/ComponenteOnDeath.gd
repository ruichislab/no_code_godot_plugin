# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteOnDeath.gd
## Ejecuta acciones al morir.
##
## **Uso:** Añade este componente para ejecutar acciones cuando la salud llega a 0.
##
## **Casos de uso:**
## - Reproducir animación de muerte
## - Soltar items
## - Reproducir sonido
## - Incrementar contador de kills
## - Desbloquear logros
##
## **Nota:** Escucha la señal 'muerte' del nodo Estadisticas.
@icon("res://icon.svg")
class_name ComponenteOnDeath
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var escena_a_instanciar: PackedScene
@export var sonido_muerte: String = "explosion"
@export var sacudida_camara: float = 0.0

var hurtbox: Node

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func _ready():
	var padre = get_parent()
	
	# Buscar Hurtbox o Destructible
	for child in padre.get_children():
		if child.has_signal("muerto"): # NC_Hurtbox
			child.muerto.connect(_on_muerte)
			hurtbox = child
			break
		elif child.has_signal("destruido"): # NC_Destructible
			child.destruido.connect(_on_muerte)
			hurtbox = child
			break

func _on_muerte():
	if escena_a_instanciar:
		var instancia = escena_a_instanciar.instantiate()
		instancia.global_position = get_parent().global_position
		get_tree().current_scene.add_child(instancia)
		
	if sonido_muerte != "":
		var sm = _get_sound_manager()
		if sm:
			if sm.has_method("play_sfx"):
				sm.play_sfx(sonido_muerte)
			elif sm.has_method("reproducir_sonido") and typeof(sonido_muerte) == TYPE_OBJECT:
				sm.reproducir_sonido(sonido_muerte)
		
	if sacudida_camara > 0 and JuiceManager:
		JuiceManager.shake_screen(sacudida_camara)
