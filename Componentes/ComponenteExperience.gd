# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteExperience.gd
## Sistema de experiencia y niveles.
##
## **Uso:** Añade este componente para crear progresión de niveles.
## Calcula XP necesaria y emite señales al subir de nivel.
##
## **Casos de uso:**
## - Sistema de niveles del jugador
## - Progresión de habilidades
## - Sistemas de prestigio
##
## **Nota:** Usa curva exponencial para balanceo.
@icon("res://icon.svg")
class_name ComponenteExperience
extends Node
const _tool_context = "RuichisLab/Nodos"

signal nivel_subido(nuevo_nivel: int)
signal experiencia_ganada(cantidad: int)

## Nivel inicial.
@export var nivel_actual: int = 1
## Experiencia actual.
@export var experiencia_actual: int = 0
## XP necesaria para el primer nivel.
@export var experiencia_base_nivel: int = 100
## Factor de curva (XP necesaria = base * nivel ^ factor).
@export var factor_curva: float = 1.5

func ganar_experiencia(cantidad: int):
	experiencia_actual += cantidad
	emit_signal("experiencia_ganada", cantidad)
	
	var necesaria = calcular_xp_necesaria()
	while experiencia_actual >= necesaria:
		experiencia_actual -= necesaria
		subir_nivel()
		necesaria = calcular_xp_necesaria()

func _get_sound_manager():
	if Engine.has_singleton("SoundManager"):
		return Engine.get_singleton("SoundManager")
	if Engine.has_singleton("AudioManager"):
		return Engine.get_singleton("AudioManager")
	if is_inside_tree():
		return get_tree().root.get_node_or_null("SoundManager") or get_tree().root.get_node_or_null("AudioManager")
	return null

func subir_nivel():
	nivel_actual += 1
	emit_signal("nivel_subido", nivel_actual)
	
	var sm = _get_sound_manager()
	if sm:
		if sm.has_method("play_sfx"):
			sm.play_sfx("levelup")
		
	if FloatingTextManager:
		FloatingTextManager.mostrar_texto("¡Nivel " + str(nivel_actual) + "!", get_parent().global_position, Color.CYAN)

func calcular_xp_necesaria() -> int:
	return int(experiencia_base_nivel * pow(nivel_actual, factor_curva))
