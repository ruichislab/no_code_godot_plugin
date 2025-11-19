# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteGameOverListener.gd
## Detecta el Game Over y ejecuta acciones.
##
## **Uso:** Añade este nodo para reaccionar automáticamente cuando el jugador muere
## o se cumple una condición de derrota.
##
## **Casos de uso:**
## - Mostrar pantalla de Game Over
## - Reproducir música de derrota
## - Reiniciar nivel automáticamente
## - Guardar estadísticas de muerte
## - Mostrar anuncios (en juegos móviles)
##
## **Nota:** Escucha la señal global 'game_over' del EventBus.
@icon("res://icon.svg")
class_name ComponenteGameOverListener
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var pantalla_game_over: Control # Nodo UI a mostrar
@export var tiempo_espera: float = 1.0
@export var sonido_game_over: String = "game_over"

func _ready():
	if GameManager:
		GameManager.game_over.connect(_on_game_over)
		
	if pantalla_game_over:
		pantalla_game_over.visible = false

func _on_game_over():
	print("ComponenteGameOver: Detectado Game Over")
	
	if tiempo_espera > 0:
		await get_tree().create_timer(tiempo_espera).timeout
		
	if SoundManager:
		SoundManager.play_sfx(sonido_game_over)
		
	if pantalla_game_over:
		pantalla_game_over.visible = true
		
		# Intentar animar si tiene modulación
		if "modulate" in pantalla_game_over:
			pantalla_game_over.modulate.a = 0
			var tween = create_tween()
			tween.tween_property(pantalla_game_over, "modulate:a", 1.0, 0.5)

# Conectar esto a un botón en la UI
func reiniciar_nivel():
	get_tree().paused = false
	get_tree().reload_current_scene()

func salir_al_menu(ruta_menu: String):
	get_tree().paused = false
	get_tree().change_scene_to_file(ruta_menu)
