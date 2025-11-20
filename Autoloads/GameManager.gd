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

# Señales globales
signal escena_cambiada(nueva_escena: String)
signal juego_pausado
signal juego_reanudado
signal evento_global(nombre: String, datos: Dictionary)

# Variables de estado
var escena_actual: String = ""
var esta_pausado: bool = false

# Referencia al jugador (puede ser nulo si no hay jugador en la escena)
var jugador: Node2D = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # No se pausa

## Cambia a una nueva escena dado su path.
func cambiar_escena(ruta: String) -> void:
	escena_actual = ruta
	var error: int = get_tree().change_scene_to_file(ruta)
	if error == OK:
		emit_signal("escena_cambiada", ruta)
		print("GameManager: Cambiando a escena: ", ruta)
	else:
		push_error("GameManager: No se pudo cambiar a la escena '%s'. Error: %d" % [ruta, error])

## Pausa el juego.
func pausar() -> void:
	get_tree().paused = true
	esta_pausado = true
	emit_signal("juego_pausado")
	print("GameManager: Juego pausado")

## Reanuda el juego.
func reanudar() -> void:
	get_tree().paused = false
	esta_pausado = false
	emit_signal("juego_reanudado")
	print("GameManager: Juego reanudado")

## Alterna entre pausa y no pausa.
func toggle_pausa() -> void:
	if get_tree().paused:
		reanudar()
	else:
		pausar()

## Emite un evento global que otros nodos pueden escuchar.
func emitir_evento(nombre: String, datos: Dictionary = {}) -> void:
	emit_signal("evento_global", nombre, datos)
	# print("GameManager: Evento emitido '", nombre, "' con datos: ", datos)

## Registra al jugador actual en el manager.
## Útil para que otros sistemas (Guardado, IA) sepan quién es el jugador.
func registrar_jugador(nodo_jugador: Node2D) -> void:
	jugador = nodo_jugador
	print("GameManager: Jugador registrado: ", jugador.name)

## Cierra el juego.
func salir_del_juego() -> void:
	print("GameManager: Cerrando juego...")
	get_tree().quit()
