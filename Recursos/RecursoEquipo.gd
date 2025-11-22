# Archivo: addons/no_code_godot_plugin/Recursos/RecursoEquipo.gd
## Item de equipamiento con modificadores.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_RecursoEquipo
extends Resource

@export var nombre: String = "Espada de Hierro"
@export var icono: Texture2D
@export_enum("Arma", "Casco", "Armadura", "Botas", "Accesorio") var tipo_slot: int = 0

# Diccionario: { "ataque": 5, "velocidad": -10 }
@export var modificadores: Dictionary = {}
