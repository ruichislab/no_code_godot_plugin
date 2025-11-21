# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSavePoint.gd
## Punto de control que permite guardar la partida.
##
## **Uso:** Hogueras, estatuas o puntos de control.
## Puede configurarse para guardar al tocar o al interactuar.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_SavePoint
extends Area2D

# --- CONFIGURACIÓN ---

## Si es true, guarda automáticamente al tocar el área.
@export var guardar_al_tocar: bool = false

## Si es true, restaura la salud del jugador al guardar.
@export var restaurar_salud: bool = true

## Sonido de confirmación.
@export var sonido_guardar: String = "save_game"

## Slot de guardado por defecto.
@export var slot: int = 1

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if guardar_al_tocar and (body.is_in_group("jugador") or body.name == "Jugador"):
		guardar()

## Método público para guardar (conectar a RL_Interaccion).
func interactuar(_actor: Node = null) -> void:
	guardar()

func guardar() -> void:
	# print("Guardando partida en Slot %d..." % slot)
	
	# 1. Guardar
	if Engine.has_singleton("SaveManager"):
		Engine.get_singleton("SaveManager").call("guardar_juego", slot)
	
	# 2. Restaurar Salud
	if restaurar_salud and Engine.has_singleton("GameManager"):
		var gm = Engine.get_singleton("GameManager")
		if gm.jugador and is_instance_valid(gm.jugador):
			var stats = gm.jugador.get_node_or_null("Estadisticas")
			if stats and stats.has_method("curar_completo"):
				stats.curar_completo()
			
	# 3. Feedback Auditivo
	if sonido_guardar != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_guardar)
		
	# 4. Feedback Visual
	if Engine.has_singleton("FloatingTextManager"):
		Engine.get_singleton("FloatingTextManager").call("mostrar_texto", "¡Partida Guardada!", global_position + Vector2(0, -50), Color.GREEN)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not Engine.has_singleton("SaveManager") and not Engine.is_editor_hint():
		# warnings.append("Se requiere el Autoload 'SaveManager' para funcionar.")
		pass
	return warnings
