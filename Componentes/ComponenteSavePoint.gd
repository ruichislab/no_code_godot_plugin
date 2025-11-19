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
	
	if SistemaGuardado:
		SistemaGuardado.guardar_juego()
		
	if restaurar_salud and GameManager and GameManager.jugador:
		if GameManager.jugador.has_node("Estadisticas"):
			GameManager.jugador.get_node("Estadisticas").curar_completo()
			
	if SoundManager:
		SoundManager.play_sfx(sonido_guardar)
		
	if FloatingTextManager:
		FloatingTextManager.mostrar_texto("¡Partida Guardada!", global_position + Vector2(0, -50), Color.GREEN)
