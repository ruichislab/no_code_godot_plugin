# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteKey.gd
## Llave coleccionable para abrir puertas.
##
## **Uso:** Añade este componente a objetos que funcionan como llaves.
## Al recogerlas, se añaden al inventario global.
##
## **Casos de uso:**
## - Llaves de puertas
## - Tarjetas de acceso
## - Gemas para portales
## - Tokens especiales
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteKey
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var id_llave: String = "llave_roja"
@export var sonido: String = "key_pickup"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		recoger()

func recoger():
	if VariableManager:
		VariableManager.set_valor(id_llave, true)
		print("Llave recogida: " + id_llave)
		
	if SoundManager:
		SoundManager.play_sfx(sonido)
		
	queue_free()
