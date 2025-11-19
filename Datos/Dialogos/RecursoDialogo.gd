# Archivo: addons/genesis_framework/Datos/Dialogos/RecursoDialogo.gd
class_name RecursoDialogo
extends Resource

@export var id_dialogo: String = ""
@export_multiline var lineas: Array[String] = []
@export var nombre_personaje: String = "NPC"
@export var retrato: Texture2D
@export var sonido_voz: AudioStream
@export var velocidad_texto: float = 0.05 # Segundos por letra
@export_enum("Arriba", "Centro", "Abajo") var posicion: String = "Abajo"

# Opciones de respuesta (Simple)
# Estructura: { "Texto Opción": "ID_Siguiente_Dialogo" }
@export var opciones: Dictionary = {}

# Acciones al terminar (ej: dar misión)
@export var acciones_al_terminar: Array[Resource] = [] # Array[GameAction]
