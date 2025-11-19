# Archivo: addons/no_code_godot_plugin/Autoloads/GameManager.gd
## Manager global para el juego.
##
## **Uso:** Autoload automático. Úsalo desde cualquier script con `GameManager.cambiar_escena()`.
##
## **Funciones:**
## - Cambio de escenas con transiciones
## - Pausar/despausar el juego
## - Bus de eventos global
## - Estado del juego

extends Node

signal escena_cambiada(nueva_escena: String)
signal juego_pausado
signal juego_reanudado
signal evento_global(nombre: String, datos: Dictionary)

var escena_actual: String = ""
var esta_pausado: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # No se pausa

## Cambia a una nueva escena.
func cambiar_escena(ruta: String):
	escena_actual = ruta
	get_tree().change_scene_to_file(ruta)
	emit_signal("escena_cambiada", ruta)
	print("GameManager: Cambiando a escena: ", ruta)

## Pausa el juego.
func pausar():
	get_tree().paused = true
	esta_pausado = true
	emit_signal("juego_pausado")
	print("GameManager: Juego pausado")

## Reanuda el juego.
func reanudar():
	get_tree().paused = false
	esta_pausado = false
	emit_signal("juego_reanudado")
	print("GameManager: Juego reanudado")

## Alterna entre pausa y no pausa.
func toggle_pausa():
	if get_tree().paused:
		reanudar()
	else:
		pausar()

## Emite un evento global que otros nodos pueden escuchar.
func emitir_evento(nombre: String, datos: Dictionary = {}):
	emit_signal("evento_global", nombre, datos)
	print("GameManager: Evento emitido '", nombre, "' con datos: ", datos)

## Cierra el juego.
func salir_del_juego():
	print("GameManager: Cerrando juego...")
	get_tree().quit()
