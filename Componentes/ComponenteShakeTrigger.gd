# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteShakeTrigger.gd
## Activa shake de cámara al entrar.
##
## **Uso:** Añade este componente para crear zonas que hacen temblar la cámara.
##
## **Casos de uso:**
## - Zonas de terremotos
## - Explosiones
## - Impactos de jefes
## - Zonas de peligro
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere ComponenteCamara.
@icon("res://icon.svg")
class_name ComponenteShakeTrigger
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var fuerza: float = 5.0
@export var duracion: float = 0.5
@export var solo_una_vez: bool = true

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		activar_shake()
		
		if solo_una_vez:
			queue_free()

func activar_shake():
	if JuiceManager:
		JuiceManager.shake_screen(fuerza, duracion)
	else:
		# Fallback: Buscar cámara manualmente
		var cam = get_viewport().get_camera_2d()
		if cam and cam.has_method("agregar_trauma"):
			cam.agregar_trauma(fuerza / 10.0)
