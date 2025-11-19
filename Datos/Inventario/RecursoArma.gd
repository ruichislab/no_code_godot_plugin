# Archivo: Datos/Inventario/RecursoArma.gd
class_name RecursoArma
extends RecursoEquipable

enum TipoArma { ESPADA, HACHA, LANZA, ARCO, BASTON }

@export_group("Estadísticas de Arma")
@export var tipo_arma: TipoArma = TipoArma.ESPADA
@export var rango_ataque: float = 50.0
@export var velocidad_ataque: float = 1.0 # Ataques por segundo
@export var costo_energia: float = 5.0

@export_group("Visuales")
@export var escena_proyectil: PackedScene # Para arcos/bastones
@export var rastro_ataque: Color = Color.WHITE

func _init():
	super._init()
	tipo_equipo = TipoEquipo.ARMA
	# Sobreescribimos valores por defecto si es necesario
