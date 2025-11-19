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
	
	var ftm = _get_floating_text_manager()
	if usar_burbuja and ftm:
		# Usamos el FloatingTextManager para mostrar el texto sobre el objeto
		ftm.mostrar_texto(texto, global_position + Vector2(0, -50), Color.WHITE, tiempo_lectura)
	else:
		var uim = _get_ui_manager()
		if uim:
			# Fallback al sistema de UI global si existe
			# uim.mostrar_mensaje(texto)
			pass

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if texto.is_empty():
		warnings.append("Define un 'texto' para que el diálogo muestre algo.")
	return warnings

func _get_floating_text_manager() -> Node:
	if Engine.has_singleton("FloatingTextManager"): return Engine.get_singleton("FloatingTextManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("FloatingTextManager")
	return null

func _get_ui_manager() -> Node:
	if Engine.has_singleton("UIManager"): return Engine.get_singleton("UIManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("UIManager")
	return null