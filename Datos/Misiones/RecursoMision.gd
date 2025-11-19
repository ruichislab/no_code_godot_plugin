# Archivo: Datos/Misiones/RecursoMision.gd
class_name RecursoMision
extends Resource

enum TipoObjetivo { MATAR, RECOLECTAR, HABLAR, VIAJAR }

@export_group("Información General")
@export var id_mision: String = ""
@export var titulo: String = "Nueva Misión"
@export_multiline var descripcion: String = "Descripción de la misión."
@export var es_principal: bool = false

@export_group("Objetivos")
@export var tipo_objetivo: TipoObjetivo = TipoObjetivo.MATAR
@export var id_objetivo: String = "" # Ej: "slime_verde" o "madera"
@export var cantidad_necesaria: int = 1

@export_group("Recompensas")
@export var experiencia: float = 100.0
@export var oro: int = 50
@export var items_recompensa: Array[RecursoObjeto] = []

# --- Lógica de Progreso (Opcional en el recurso, mejor en un Manager) ---
# Este recurso solo debería contener DATOS estáticos.
