# Archivo: addons/no_code_godot_plugin/Recursos/RecursoMision.gd
## Definición de datos para una Misión (Quest).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name ResourceMision
extends Resource

@export_group("Info General")
@export var id_mision: String = "mision_01"
@export var titulo: String = "Título de la Misión"
@export_multiline var descripcion: String = "Descripción detallada de lo que hay que hacer."

@export_group("Objetivos")
## ID del evento que hace avanzar esta misión (ej: "matar_rata", "recoger_madera").
@export var id_objetivo: String = "matar_rata"
## Cantidad necesaria para completar.
@export var cantidad_necesaria: int = 1

@export_group("Recompensas")
@export var experiencia: int = 100
@export var oro: int = 50
@export var items_recompensa: Array[Resource] = [] # ResourceCardData o similar
