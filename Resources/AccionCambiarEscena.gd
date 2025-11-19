# Archivo: addons/no_code_godot_plugin/Resources/AccionCambiarEscena.gd
## Acción: Cambia a otra escena.
##
## **Uso:** Crea un recurso de este tipo y asígnalo al array de acciones del Trigger.

class_name AccionCambiarEscena
extends AccionBase

@export_file("*.tscn") var ruta_escena: String = ""

func ejecutar(actor: Node = null) -> void:
    if ruta_escena.is_empty():
        push_error("AccionCambiarEscena: No se especificó una escena")
        return

    if GameManager:
        GameManager.cambiar_escena(ruta_escena)
    else:
        # Fallback sin GameManager
        get_tree().change_scene_to_file(ruta_escena)
        return
