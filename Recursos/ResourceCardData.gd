# Archivo: addons/no_code_godot_plugin/Recursos/ResourceCardData.gd
## Datos de una Carta.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_RecursoCarta
extends Resource

@export var id: String = "carta_nueva"
@export var nombre: String = "Nombre Carta"
@export_multiline var descripcion: String = "Efecto..."
@export var coste: int = 1
@export var icono: Texture2D
@export var tipo: String = "Ataque"
@export var valor: int = 5
