# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTurnManager.gd
## Gestor de turnos para juegos por turnos.
##
## **Uso:** Añade este componente para crear sistemas de combate por turnos.
## Maneja el orden de turnos y las transiciones.
##
## **Casos de uso:**
## - RPGs por turnos
## - Juegos de estrategia
## - Juegos de cartas
## - Combate táctico
##
## **Nota:** Emite señales cuando cambia el turno.
@icon("res://icon.svg")
class_name ComponenteTurnManager
extends Node
const _tool_context = "RuichisLab/Nodos"

signal turno_iniciado(equipo: String)
signal turno_terminado(equipo: String)
signal ronda_completada(numero_ronda: int)

@export var equipos: Array[String] = ["Jugador", "Enemigo"]
@export var auto_iniciar: bool = true

var indice_equipo_actual: int = 0
var ronda_actual: int = 1
var turno_activo: bool = false

func _ready():
	if auto_iniciar:
		call_deferred("iniciar_combate")

func iniciar_combate():
	indice_equipo_actual = 0
	ronda_actual = 1
	_iniciar_turno()

func siguiente_turno():
	if not turno_activo: return
	
	emit_signal("turno_terminado", equipos[indice_equipo_actual])
	turno_activo = false
	
	indice_equipo_actual += 1
	if indice_equipo_actual >= equipos.size():
		indice_equipo_actual = 0
		ronda_actual += 1
		emit_signal("ronda_completada", ronda_actual)
		
	_iniciar_turno()

func _iniciar_turno():
	turno_activo = true
	var equipo = equipos[indice_equipo_actual]
	print("Turno: " + equipo + " (Ronda " + str(ronda_actual) + ")")
	emit_signal("turno_iniciado", equipo)

func obtener_equipo_actual() -> String:
	return equipos[indice_equipo_actual]
