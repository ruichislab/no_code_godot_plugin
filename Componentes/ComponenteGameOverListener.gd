# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteGameOverListener.gd
## Escucha eventos globales de Game Over y ejecuta lógica de respuesta.
##
## **Uso:** Añadir en la escena del nivel o en una capa de UI.
## **Requisito:** Espera que el GameManager emita la señal `game_over` o un evento global equivalente.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_GameOverListener
extends Node

# --- CONFIGURACIÓN ---

## Nodo de UI (Control) que se mostrará al perder.
@export var pantalla_game_over: Control

## Tiempo de espera antes de mostrar la pantalla (segundos).
@export var tiempo_espera: float = 1.0

## Sonido a reproducir (vía AudioManager).
@export var sonido_game_over: String = "game_over"

## Si es true, pausa el juego al activarse (después del delay).
@export var pausar_juego: bool = true

func _ready() -> void:
	# Conectar con GameManager (evento global o señal específica)
	if Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		if gm.has_signal("evento_global"):
			gm.evento_global.connect(_on_evento_global)
		if gm.has_signal("game_over"): # Compatibilidad si se añade señal explícita
			gm.game_over.connect(_on_game_over)
		
	if pantalla_game_over:
		pantalla_game_over.visible = false

func _on_evento_global(nombre: String, _datos: Dictionary) -> void:
	if nombre == "game_over" or nombre == "player_died":
		_on_game_over()

func _on_game_over() -> void:
	# print("RL_GameOverListener: Detectado Game Over")
	
	if tiempo_espera > 0:
		await get_tree().create_timer(tiempo_espera).timeout
		
	# Sonido
	if sonido_game_over != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_game_over)
		
	# UI
	if pantalla_game_over:
		pantalla_game_over.visible = true
		
		# Animación simple de fade in
		pantalla_game_over.modulate.a = 0
		var tween = create_tween()
		tween.tween_property(pantalla_game_over, "modulate:a", 1.0, 1.0)

	if pausar_juego:
		get_tree().paused = true

# --- FUNCIONES DE UTILIDAD (para conectar a botones de la UI de Game Over) ---

## Reinicia la escena actual.
func reiniciar_nivel() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

## Carga el menú principal.
func salir_al_menu(ruta_menu: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(ruta_menu)
