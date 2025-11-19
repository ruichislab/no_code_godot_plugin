# Archivo: addons/no_code_godot_plugin/Resources/AccionBase.gd
## Clase base para acciones del Trigger.
##
## Extiende de esta clase para crear nuevas acciones personalizadas.
## Ejemplo: AccionReproducirSonido, AccionCambiarEscena, etc.

class_name AccionBase
extends Resource

## Método que se ejecuta cuando el trigger se activa.
## @param actor: El nodo que activó el trigger (generalmente el jugador).
func ejecutar(actor: Node = null):
	push_warning("AccionBase.ejecutar() no ha sido sobrescrita en la clase hija")
