# Archivo: Datos/Efectos/RecursoEfecto.gd
class_name RecursoEfecto
extends Resource

enum TipoEfecto { BUFF, DEBUFF }

@export var id_efecto: String = ""
@export var nombre: String = "Efecto"
@export var descripcion: String = ""
@export var icono: Texture2D
@export var tipo: TipoEfecto = TipoEfecto.DEBUFF
@export var duracion: float = 5.0 # Segundos. 0 = Infinito/Instantáneo
@export var es_acumulable: bool = false
@export var max_acumulaciones: int = 1

# --- MÉTODOS VIRTUALES ---

# Se llama al aplicar el efecto
func al_aplicar(objetivo: Node):
	pass

# Se llama al remover el efecto (por tiempo o cura)
func al_remover(objetivo: Node):
	pass

# Se llama cada frame (o cada X tiempo) si el componente lo gestiona
func al_actualizar(objetivo: Node, delta: float):
	pass
