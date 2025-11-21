# Archivo: addons/no_code_godot_plugin/Recursos/RecursoMision.gd
## Definición de datos para una Misión (Quest).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_RecursoMision
extends Resource

@export_group("Información General")
## Identificador único para seguimiento interno.
@export var id_mision: String = "mision_01"
## Título visible para el jugador.
@export var titulo: String = "Título de la Misión"
## Descripción detallada.
@export_multiline var descripcion: String = "Descripción..."
## Icono opcional.
@export var icono: Texture2D

@export_group("Objetivos")
## ID del evento global que hace avanzar esta misión.
@export var id_objetivo: String = "evento_generico"
## Cantidad necesaria.
@export var cantidad_necesaria: int = 1

@export_group("Recompensas")
## Puntos de experiencia.
@export var experiencia: int = 100
## Monedas de oro.
@export var oro: int = 50
## Items a entregar.
@export var items_recompensa: Array[Resource] = []
