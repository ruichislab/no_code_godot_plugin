# Archivo: Componentes/ComponenteInteraccion.gd
## Zona de interacción con objetos del mundo.
##
## **Uso:** Añade este componente a objetos interactuables (NPCs, cofres, palancas).
## Muestra un indicador visual cuando el jugador está cerca y puede interactuar.
##
## **Casos de uso:**
## - NPCs con los que hablar
## - Cofres que se pueden abrir
## - Palancas y botones
## - Objetos examinables
## - Puertas que requieren llave
##
## **Requisito:** Debe ser hijo de un Area2D. El jugador debe presionar la tecla de acción.
class_name ComponenteInteraccion
extends Area2D
const _tool_context = "RuichisLab/Nodos"

# --- SEÑALES ---
signal interactuado(jugador: Node)
signal jugador_entro_rango
signal jugador_salio_rango

# --- CONFIGURACIÓN ---
@export var texto_interaccion: String = "Interactuar"
@export var tecla_accion: String = "ui_accept" # Por defecto 'Enter' o 'Espacio'
@export var es_interactuable: bool = true

# --- ESTADO ---
var jugador_en_rango: Node = null

func _ready():
	# Configuración automática de colisiones si no se ha hecho en el editor
	collision_layer = 0 
	collision_mask = 1 # Asumimos que el jugador está en la capa 1
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Asegurarse de que monitorable/monitoring estén activos
	monitoring = true
	monitorable = false

func _input(event):
	if not es_interactuable or not jugador_en_rango: return
	
	if event.is_action_pressed(tecla_accion):
		interactuar()

func interactuar():
	print("Interactuando con: " + get_parent().name)
	emit_signal("interactuado", jugador_en_rango)

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		jugador_en_rango = body
		emit_signal("jugador_entro_rango")
		# Aquí podrías mostrar un UI prompt (ej: "Presiona E")

func _on_body_exited(body):
	if body == jugador_en_rango:
		jugador_en_rango = null
		emit_signal("jugador_salio_rango")
		# Aquí ocultarías el UI prompt

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if texto_interaccion.is_empty():
		warnings.append("Define un 'texto_interaccion' para que el jugador sepa qué puede hacer.")
	return warnings