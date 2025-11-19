# Archivo: Datos/Acciones/GameAction.gd
class_name GameAction
extends Resource

# Clase base para el sistema de "Visual Scripting" con Recursos.
# Hereda de esta clase para crear bloques de lógica (ej: AccionSonido, AccionSpawn).

func ejecutar(nodo_origen: Node = null):
	print("Ejecutando acción base (sin efecto).")
