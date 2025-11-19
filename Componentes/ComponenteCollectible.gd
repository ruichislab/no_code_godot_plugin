# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd
## Item coleccionable genérico.
##
## **Uso:** Añade este componente a objetos que el jugador puede recoger.
## Se añade automáticamente al inventario.
##
## **Casos de uso:**
## - Monedas
## - Gemas
## - Power-ups
## - Items de quest
## - Munición
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteCollectible
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var nombre_variable: String = "monedas"
@export var valor_a_sumar: int = 1
@export var sonido_recoger: String = "coin"
@export var eliminar_al_recoger: bool = true

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		recoger()

func recoger():
	# 1. Modificar Variable
	if VariableManager:
		VariableManager.sumar_valor(nombre_variable, valor_a_sumar)
		print("Variable %s: %s" % [nombre_variable, VariableManager.obtener_valor(nombre_variable)])
	
	# 2. Sonido
	if SoundManager:
		SoundManager.play_sfx(sonido_recoger)
		
	# 3. Efecto visual (Opcional: spawnear partículas aquí)
	
	# 4. Eliminar
	if eliminar_al_recoger:
		queue_free()
