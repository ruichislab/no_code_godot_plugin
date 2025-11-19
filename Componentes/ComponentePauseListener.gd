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
	
	if GameManager:
		GameManager.juego_pausado.connect(_on_juego_pausado)
		
	if pantalla_pausa:
		pantalla_pausa.visible = false

func _on_juego_pausado(esta_pausado: bool):
	if pantalla_pausa:
		pantalla_pausa.visible = esta_pausado
		
	if SoundManager:
		if esta_pausado:
			SoundManager.play_sfx(sonido_pausa)
		else:
			SoundManager.play_sfx(sonido_reanudar)

# Conectar esto a un botón "Reanudar" en la UI
func reanudar():
	if GameManager:
		GameManager.alternar_pausa()
