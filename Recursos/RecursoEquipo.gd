# Archivo: addons/no_code_godot_plugin/Recursos/RecursoEquipo.gd
## Define un item de equipamiento.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name ResourceEquipment
extends Resource

@export var nombre: String = "Espada de Hierro"
@export var icono: Texture2D
@export_enum("Arma", "Casco", "Armadura", "Botas", "Accesorio") var tipo_slot: int = 0

# Diccionario de stats que modifica: { "ataque": 5, "velocidad": -10 }
@export var modificadores: Dictionary = {}
