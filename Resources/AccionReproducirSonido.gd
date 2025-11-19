# Archivo: addons/no_code_godot_plugin/Resources/AccionReproducirSonido.gd
## Acción: Reproduce un sonido.
##
## **Uso:** Crea un recurso de este tipo y asígnalo al array de acciones del Trigger.

class_name AccionReproducirSonido
extends AccionBase

@export var sonido: AudioStream
@export_range(0.0, 2.0) var volumen: float = 1.0

func ejecutar(actor: Node = null):
	if not sonido:
		push_warning("AccionReproducirSonido: No se asignó ningún sonido")
		return
	
	if AudioManager:
		AudioManager.reproducir_sonido(sonido, volumen)
	else:
		push_warning("AccionReproducirSonido: AudioManager no está disponible")
