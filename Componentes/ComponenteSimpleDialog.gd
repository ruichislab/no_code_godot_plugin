# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSimpleDialog.gd
## Sistema de diálogos simple (texto plano).
##
## **Uso:** Añade este componente para mostrar mensajes de texto cuando el jugador
## entra en el área. Ideal para tutoriales y mensajes rápidos.
##
## **Casos de uso:**
## - Carteles informativos
## - Tutoriales in-game
## - Pensamientos del personaje
## - Mensajes de sistema
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteSimpleDialog
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export_multiline var texto: String = "Hola viajero."
@export var usar_burbuja: bool = true
@export var tiempo_lectura: float = 3.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		mostrar_texto()

func mostrar_texto():
	print("NPC dice: " + texto)
	
	if usar_burbuja and FloatingTextManager:
		# Usamos el FloatingTextManager para mostrar el texto sobre el objeto
		FloatingTextManager.mostrar_texto(texto, global_position + Vector2(0, -50), Color.WHITE, tiempo_lectura)
	elif UIManager:
		# Fallback al sistema de UI global si existe
		# UIManager.mostrar_mensaje(texto)
		pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if texto.is_empty():
		warnings.append("Define un 'texto' para que el diálogo muestre algo.")
	return warnings
