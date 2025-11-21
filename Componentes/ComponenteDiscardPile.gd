# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDiscardPile.gd
## Pila de descarte (Cementerio).
##
## **Uso:** Almacena datos de cartas jugadas o descartadas.
## Puede conectarse a un `RL_Deck` para reciclarse.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_DiscardPile
extends Node

# --- SEÑALES ---
signal carta_agregada(data: RL_RecursoCarta)
signal pila_vaciada

# --- ESTADO ---
var cartas: Array[RL_RecursoCarta] = []

## Añade una carta a la pila.
func agregar_carta(data: RL_RecursoCarta) -> void:
	if not data: return
	cartas.append(data)
	emit_signal("carta_agregada", data)
	# print("Carta descartada: ", data.get("nombre", "???"))

## Vacía la pila y devuelve las cartas (para barajar de nuevo al mazo).
func vaciar() -> Array[RL_RecursoCarta]:
	var temp = cartas.duplicate()
	cartas.clear()
	emit_signal("pila_vaciada")
	return temp

## Devuelve la cantidad actual.
func cantidad() -> int:
	return cartas.size()
