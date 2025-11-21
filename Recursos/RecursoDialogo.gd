# Archivo: addons/no_code_godot_plugin/Recursos/RecursoDialogo.gd
## Datos de una conversación (Visual Novel).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_RecursoDialogo
extends Resource

# Array de diccionarios: { "personaje": "X", "texto": "...", "retrato": Texture }
@export var conversacion: Array[Dictionary] = []
