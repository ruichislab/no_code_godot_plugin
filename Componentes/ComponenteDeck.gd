# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDeck.gd
## Gestor del Mazo y Robo de cartas.
##
## **Uso:** Gestiona la lógica de robar, barajar y el descarte.
## **Requisito:** Nodo simple. Requiere referencias a `RL_Hand` y una escena de carta.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Deck
extends Node

# --- CONFIGURACIÓN ---

## Lista inicial de recursos (RL_RecursoCarta) que componen el mazo.
@export var cartas_iniciales: Array[RL_RecursoCarta] = []

## Referencia al nodo `RL_Hand` donde aparecerán las cartas robadas.
@export var mano_objetivo: Control

## PackedScene de la carta visual (debe contener `RL_Card`).
@export var escena_carta: PackedScene

## Si es true, baraja automáticamente al iniciar.
@export var barajar_al_inicio: bool = true

# --- ESTADO ---
var mazo_actual: Array[RL_RecursoCarta] = []
var descarte: Array[RL_RecursoCarta] = []

func _ready() -> void:
	reiniciar_mazo()

func reiniciar_mazo() -> void:
	mazo_actual = cartas_iniciales.duplicate()
	descarte.clear()
	if barajar_al_inicio:
		barajar()

func barajar() -> void:
	mazo_actual.shuffle()
	# print("Mazo barajado. Cartas: ", mazo_actual.size())

## Roba una carta y la instancia en la mano.
func robar_carta() -> void:
	if mazo_actual.is_empty():
		if descarte.is_empty():
			print("Deck vacío: No quedan cartas.")
			return
		else:
			_reciclar_descarte()
	
	var data = mazo_actual.pop_back()
	_instanciar_carta_en_mano(data)

func _instanciar_carta_en_mano(data: RL_RecursoCarta) -> void:
	if not mano_objetivo:
		push_error("RL_Deck: No hay mano_objetivo asignada.")
		return
	if not escena_carta:
		push_error("RL_Deck: No hay escena_carta asignada.")
		return
		
	var instancia = escena_carta.instantiate()
	
	# Configurar datos
	if instancia.has_method("configurar"):
		instancia.configurar(data)
	elif instancia is RL_Card:
		instancia.data_carta = data
	elif instancia.has_node("RL_Card"): # Si la escena tiene RL_Card como hijo
		instancia.get_node("RL_Card").configurar(data)

	mano_objetivo.add_child(instancia)

func _reciclar_descarte() -> void:
	# print("Reciclando descarte...")
	mazo_actual.append_array(descarte)
	descarte.clear()
	barajar()

## Añade una carta al descarte (usar cuando se juega una carta).
func descartar(data: RL_RecursoCarta) -> void:
	descarte.append(data)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not mano_objetivo:
		warnings.append("Asigna una 'Mano Objetivo' (Control/RL_Hand).")
	if not escena_carta:
		warnings.append("Asigna una 'Escena Carta' (.tscn).")
	return warnings
