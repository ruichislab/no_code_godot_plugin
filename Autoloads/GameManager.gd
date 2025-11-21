# Archivo: addons/no_code_godot_plugin/Autoloads/GameManager.gd
## Manager global para gestión de juego, escenas y estado.
##
## **Mejoras Pro:** Carga de escenas asíncrona (Threaded), transiciones visuales y manejo de pausa robusto.
extends Node

# --- SEÑALES ---
signal escena_cambiada(nueva_escena: String)
signal juego_pausado
signal juego_reanudado
signal evento_global(nombre: String, datos: Dictionary)
signal carga_progreso(porcentaje: float) # 0.0 a 1.0

# --- CONFIGURACIÓN ---
const TRANSITION_SCENE_PATH: String = "res://addons/no_code_godot_plugin/Servicios/SceneTransition.gd"

# --- ESTADO ---
var escena_actual: String = ""
var esta_pausado: bool = false
var jugador: Node2D = null

# Estado de carga
var _loader_path: String = ""
var _loading_status: int = 0
var _progress: Array = []
var _use_sub_threads: bool = true
var _transition_node: Node = null # Instancia de SceneTransition

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Instanciar transicionador si no existe
	# Nota: Idealmente SceneTransition sería un Autoload separado, pero lo gestionamos aquí para simplificar setup
	var transition_script = load(TRANSITION_SCENE_PATH)
	if transition_script:
		_transition_node = transition_script.new()
		_transition_node.name = "SceneTransitionOverlay"
		add_child(_transition_node)

## Cambia de escena con transición y carga asíncrona.
func cambiar_escena(ruta: String, usar_transicion: bool = true) -> void:
	if ruta == "": return
	escena_actual = ruta

	if usar_transicion and _transition_node:
		_transition_node.transicion_fade(0.5)
		await _transition_node.transicion_mitad_completada

	# Iniciar carga en segundo plano
	var err = ResourceLoader.load_threaded_request(ruta, "", _use_sub_threads)
	if err != OK:
		push_error("GameManager: Error al iniciar carga de escena: %s" % ruta)
		return

	_loader_path = ruta
	set_process(true) # Activar monitoreo de carga

func _process(_delta: float) -> void:
	if _loader_path == "":
		set_process(false)
		return

	_loading_status = ResourceLoader.load_threaded_get_status(_loader_path, _progress)

	if _progress.size() > 0:
		emit_signal("carga_progreso", _progress[0])

	if _loading_status == ResourceLoader.THREAD_LOAD_LOADED:
		# Carga completa
		var nueva_escena = ResourceLoader.load_threaded_get(_loader_path)
		get_tree().change_scene_to_packed(nueva_escena)

		emit_signal("escena_cambiada", _loader_path)
		_loader_path = ""

		# Finalizar transición
		if _transition_node:
			_transition_node.finalizar_transicion(0.5)

	elif _loading_status == ResourceLoader.THREAD_LOAD_FAILED or _loading_status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		push_error("GameManager: Falló la carga de escena.")
		_loader_path = ""
		if _transition_node: _transition_node.finalizar_transicion(0.1)

## Pausa el juego.
func pausar() -> void:
	get_tree().paused = true
	esta_pausado = true
	emit_signal("juego_pausado")

## Reanuda el juego.
func reanudar() -> void:
	get_tree().paused = false
	esta_pausado = false
	emit_signal("juego_reanudado")

## Alterna entre pausa y no pausa.
func toggle_pausa() -> void:
	if get_tree().paused:
		reanudar()
	else:
		pausar()

## Emite un evento global.
func emitir_evento(nombre: String, datos: Dictionary = {}) -> void:
	emit_signal("evento_global", nombre, datos)

## Registra al jugador actual.
func registrar_jugador(nodo_jugador: Node2D) -> void:
	jugador = nodo_jugador

## Cierra el juego.
func salir_del_juego() -> void:
	get_tree().quit()
