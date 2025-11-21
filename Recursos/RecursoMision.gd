# Archivo: addons/no_code_godot_plugin/Recursos/RecursoMision.gd
## Definición de datos para una Misión (Quest).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name ResourceMision
extends Resource

@export_group("Información General")
## Identificador único para seguimiento interno (ej: 'mision_tutorial_01').
@export var id_mision: String = "mision_01"

## Título visible para el jugador.
@export var titulo: String = "Título de la Misión"

## Descripción detallada de la tarea.
@export_multiline var descripcion: String = "Descripción detallada..."

## Icono opcional para mostrar en la UI.
@export var icono: Texture2D

@export_group("Objetivos")
## ID del evento global que hace avanzar esta misión (ej: 'matar_rata', 'recoger_madera').
@export var id_objetivo: String = "evento_generico"

## Cantidad necesaria para completar el objetivo.
@export var cantidad_necesaria: int = 1

@export_group("Recompensas")
## Puntos de experiencia a otorgar.
@export var experiencia: int = 100

## Monedas de oro a otorgar.
@export var oro: int = 50

## Lista de items (Recursos) a entregar.
@export var items_recompensa: Array[Resource] = []
