# Archivo: addons/genesis_framework/Datos/AI/BehaviorTree/Blackboard.gd
class_name Blackboard
extends RefCounted

# Memoria compartida para la IA.
# Permite que diferentes nodos del árbol compartan información.

var datos: Dictionary = {}

func set_valor(clave: String, valor: Variant):
	datos[clave] = valor

func get_valor(clave: String, defecto: Variant = null) -> Variant:
	return datos.get(clave, defecto)

func tiene_valor(clave: String) -> bool:
	return datos.has(clave)

func borrar_valor(clave: String):
	datos.erase(clave)

func limpiar():
	datos.clear()
