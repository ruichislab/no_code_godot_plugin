# Archivo: addons/no_code_godot_plugin/Componentes/ComponentePauseListener.gd
## Detecta cuando el juego se pausa/despausa.
##
## **Uso:** Añade este nodo para ejecutar acciones cuando el jugador pausa el juego.
##
## **Casos de uso:**
## - Mostrar/ocultar menú de pausa
## - Detener música de fondo
## - Mostrar consejos durante la pausa
## - Guardar progreso automáticamente
##
## **Nota:** Escucha la señal 'game_paused' del EventBus.
@icon("res://icon.svg")
class_name ComponentePauseListener
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var pantalla_pausa: Control # Nodo UI a mostrar
@export var sonido_pausa: String = "pause_on"
@export var sonido_reanudar: String = "pause_off"

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # Debe funcionar en pausa
	
	var gm = _get_game_manager()
	if gm:
		gm.juego_pausado.connect(_on_juego_pausado)
		
	if pantalla_pausa:
		pantalla_pausa.visible = false

func _on_juego_pausado(esta_pausado: bool):
	if pantalla_pausa:
		pantalla_pausa.visible = esta_pausado
		
	var sm = _get_sound_manager()
	if sm:
		if esta_pausado:
			# sm.play_sfx(sonido_pausa)
			pass
		else:
			# sm.play_sfx(sonido_reanudar)
			pass

# Conectar esto a un botón "Reanudar" en la UI
func reanudar():
	var gm = _get_game_manager()
	if gm:
		gm.alternar_pausa()

func _get_game_manager() -> Node:
	if Engine.has_singleton("GameManager"): return Engine.get_singleton("GameManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GameManager")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null
