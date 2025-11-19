# Archivo: addons/no_code_godot_plugin/Resources/AccionMostrarMensaje.gd
## Acción: Muestra un mensaje en consola.
##
## **Uso:** Crea un recurso de este tipo y asígnalo al array de acciones del Trigger.
## Útil para debugging o para emitir eventos personalizados.

class_name AccionMostrarMensaje
extends AccionBase

@export_multiline var mensaje: String = "¡Trigger activado!"
@export var emitir_evento_global: bool = false
@export var nombre_evento: String = "mensaje_mostrado"

func ejecutar(actor: Node = null):
	print("=== MENSAJE DEL TRIGGER ===")
	print(mensaje)
	print("===========================")
	
	if emitir_evento_global and GameManager:
		GameManager.emitir_evento(nombre_evento, {"mensaje": mensaje, "actor": actor})
