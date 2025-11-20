# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCardSlot.gd
## Contenedor que acepta cartas arrastradas (Drop Zone).
##
## **Uso:** Slots de equipo, zonas de juego, cementerio.
## **Requisito:** Control (PanelContainer, etc.).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_CardSlot
extends PanelContainer

# --- SEÑALES ---
signal carta_recibida(carta: RL_Card)
signal carta_removida(carta: RL_Card)

# --- CONFIGURACIÓN ---

## Si no está vacío, solo acepta cartas con este tipo (string en ResourceCardData.tipo).
@export var filtro_tipo: String = ""

## Número máximo de cartas en este slot.
@export var capacidad_maxima: int = 1

func _ready() -> void:
	# Asegurar que los hijos no bloqueen el drop
	mouse_filter = Control.MOUSE_FILTER_STOP

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Verificar formato de datos
	if typeof(data) != TYPE_DICTIONARY or not data.has("tipo") or data.tipo != "RL_CARD":
		return false

	var carta = data.referencia as RL_Card
	var info = data.data as ResourceCardData

	# Verificar Capacidad
	if get_child_count() >= capacidad_maxima:
		return false

	# Verificar Filtro
	if filtro_tipo != "" and info and info.tipo != filtro_tipo:
		return false

	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var carta = data.referencia as RL_Card
	if not carta: return

	# Lógica de transferencia
	var padre_anterior = carta.get_parent()
	if padre_anterior:
		padre_anterior.remove_child(carta)

	add_child(carta)

	# Resetear transformaciones visuales del drag
	carta.position = Vector2.ZERO
	carta.size = size # Ajustar al slot si se desea

	emit_signal("carta_recibida", carta)

	# Si la carta tenía señal, reconectarla o notificar
	# if carta.has_signal("carta_jugada"): ...

func remover_carta(carta: RL_Card) -> void:
	if carta.get_parent() == self:
		remove_child(carta)
		emit_signal("carta_removida", carta)
