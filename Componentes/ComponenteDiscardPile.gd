class_name ComponenteDiscardPile
extends Node
const _tool_context = "RuichisLab/Nodos"

var cartas_descartadas: Array[ResourceCardData] = []

func agregar_carta(data: ResourceCardData):
	cartas_descartadas.append(data)
	print("Carta descartada: ", data.nombre if data else "Desconocida")

func vaciar() -> Array[ResourceCardData]:
	var cartas = cartas_descartadas.duplicate()
	cartas_descartadas.clear()
	return cartas