# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSavePoint.gd
## Punto de guardado manual.
##
## **Uso:** Añade este componente para crear puntos donde el jugador puede guardar.
## Se integra con el SistemaGuardado automáticamente.
##
## **Casos de uso:**
## - Hogueras (Dark Souls)
## - Cabinas telefónicas
## - Camas de descanso
## - Estatuas de guardado
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere SistemaGuardado activo.
@icon("res://icon.svg")
class_name ComponenteSavePoint
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var restaurar_salud: bool = true
@export var sonido_guardar: String = "save_game"

func _ready():
	# Se puede activar por colisión o interacción
	pass

# Llamado por ComponenteInteraccion
func interactuar():
	guardar()

func guardar():
	print("Guardando partida...")
	
	var sg = _get_save_system()
	if sg:
		sg.guardar_juego()
	
	var gm = _get_game_manager()
	if restaurar_salud and gm and gm.jugador:
		if gm.jugador.has_node("Estadisticas"):
			gm.jugador.get_node("Estadisticas").curar_completo()
			
	var sm = _get_sound_manager()
	if sm:
		# sm.play_sfx(sonido_guardar)
		pass
		
	var ftm = _get_floating_text_manager()
	if ftm:
		ftm.mostrar_texto("¡Partida Guardada!", global_position + Vector2(0, -50), Color.GREEN)

func _get_save_system() -> Node:
	if Engine.has_singleton("SistemaGuardado"): return Engine.get_singleton("SistemaGuardado")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SistemaGuardado")
	return null

func _get_game_manager() -> Node:
	if Engine.has_singleton("GameManager"): return Engine.get_singleton("GameManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GameManager")
	return null

func _get_sound_manager() -> Node:
	if Engine.has_singleton("SoundManager"): return Engine.get_singleton("SoundManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("SoundManager")
	return null

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null
