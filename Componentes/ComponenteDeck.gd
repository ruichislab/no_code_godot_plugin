@icon("res://icon.svg")
class_name ComponenteDeck
extends Node
const _tool_context = "RuichisLab/Nodos"

## Lista de datos de cartas que componen el mazo.
@export var cartas_iniciales: Array[ResourceCardData] = []

## Referencia a la mano donde se instanciarán las cartas.
@export var mano_objetivo: ComponenteHand

## Escena base de la carta visual (debe tener ComponenteCard).
@export var carta_scene: PackedScene

var mazo_actual: Array[ResourceCardData] = []
var descarte: Array[ResourceCardData] = []

func _ready():
	mazo_actual = cartas_iniciales.duplicate()
	barajar()

func barajar():
	mazo_actual.shuffle()
	print("Mazo barajado. Cartas restantes: ", mazo_actual.size())

func robar_carta():
	if mazo_actual.is_empty():
		if descarte.is_empty():
			print("No quedan cartas en el mazo ni en el descarte.")
			return
		else:
			reciclar_descarte()
	
	var data = mazo_actual.pop_back()
	_instanciar_carta(data)

func _instanciar_carta(data: ResourceCardData):
	if not mano_objetivo or not carta_scene:
		push_error("ComponenteDeck: Falta asignar 'mano_objetivo' o 'carta_scene'.")
		return
		
	var nueva_carta = carta_scene.instantiate()
	if nueva_carta.has_method("configurar"):
		nueva_carta.configurar(data)
	elif "id_carta" in nueva_carta: # Fallback a propiedades directas
		nueva_carta.id_carta = data.id
		# Asignar otras props si existen
	
	mano_objetivo.add_child(nueva_carta)

func reciclar_descarte():
	mazo_actual.append_array(descarte)
	descarte.clear()
	barajar()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not mano_objetivo:
		warnings.append("Asigna un nodo 'ComponenteHand' en 'mano_objetivo' para saber dónde poner las cartas robadas.")
	if not carta_scene:
		warnings.append("Asigna una escena con 'ComponenteCard' en 'carta_scene' para poder instanciar cartas.")
	return warnings
