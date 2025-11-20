# Archivo: addons/no_code_godot_plugin/Recursos/ResourceCardData.gd
## Recurso base para definir los datos de una carta.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name ResourceCardData
extends Resource

@export var id: String = "carta_nueva"
@export var nombre: String = "Nombre de Carta"
@export_multiline var descripcion: String = "Descripción del efecto."
@export var coste: int = 1
@export var icono: Texture2D
@export var tipo: String = "Ataque" # Ataque, Habilidad, Poder
@export var valor: int = 5 # Daño, Escudo, Curación
