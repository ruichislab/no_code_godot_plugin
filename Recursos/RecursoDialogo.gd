# Archivo: addons/no_code_godot_plugin/Recursos/RecursoDialogo.gd
## Recurso para definir conversaciones completas.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name ResourceDialogo
extends Resource

# Array de diccionarios. Cada entrada representa una línea.
# Formato:
# {
#   "personaje": "Nombre",
#   "texto": "Hola mundo",
#   "retrato": Texture2D (opcional),
#   "opciones": [{"texto": "Si", "next_id": 5}, {"texto": "No", "next_id": -1}]
# }
@export var conversacion: Array[Dictionary] = [
	{
		"personaje": "Guía",
		"texto": "Bienvenido al juego.",
		"retrato": null
	}
]
