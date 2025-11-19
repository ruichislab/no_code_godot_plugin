class_name ResourceCardData
extends Resource

@export var id: String = "card_id"
@export var nombre: String = "Nombre Carta"
@export_multiline var descripcion: String = "Descripción de la carta."
@export var coste: int = 1
@export var icono: Texture2D
@export var script_acciones: Script # Script que extiende de un 'CardAction' base opcional
