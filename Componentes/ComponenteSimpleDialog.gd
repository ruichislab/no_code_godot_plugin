# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSimpleDialog.gd
## Muestra textos simples al entrar en el área.
##
## **Uso:** Carteles, tutoriales o pensamientos rápidos.
## Intenta usar FloatingTextManager o UIManager para visualizar el texto.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_SimpleDialog
extends Area2D

# --- CONFIGURACIÓN ---

## El mensaje a mostrar.
@export_multiline var texto: String = "Hola viajero."

## Si es true, intenta mostrarlo como burbuja flotante sobre el objeto.
@export var usar_burbuja: bool = true

## Duración del mensaje en pantalla.
@export var tiempo_lectura: float = 3.0

## Offset vertical para la burbuja.
@export var offset_y: float = -50.0

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		mostrar_texto()

func mostrar_texto() -> void:
	# print("NPC dice: " + texto)
	
	# 1. Intentar Floating Text (Burbuja)
	if usar_burbuja and Engine.has_singleton("FloatingTextManager"):
		var ftm = Engine.get_singleton("FloatingTextManager")
		if ftm.has_method("mostrar_texto"):
			ftm.mostrar_texto(texto, global_position + Vector2(0, offset_y), Color.WHITE, tiempo_lectura)
			return # Éxito

	# 2. Intentar UI Manager (Caja de texto inferior)
	if Engine.has_singleton("UIManager"):
		var uim = Engine.get_singleton("UIManager")
		if uim.has_method("mostrar_mensaje"):
			uim.mostrar_mensaje(texto, tiempo_lectura)
		else:
			# Fallback consola si no hay UI
			print("[Dialogo]: ", texto)
	else:
		print("[Dialogo]: ", texto)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if texto.is_empty():
		warnings.append("El campo 'texto' está vacío.")
	return warnings
