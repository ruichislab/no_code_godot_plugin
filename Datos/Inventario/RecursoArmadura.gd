# Archivo: Datos/Inventario/RecursoArmadura.gd
class_name RecursoArmadura
extends RecursoEquipable

enum TipoArmadura { TELA, CUERO, MALLA, PLACAS }
enum SlotArmadura { CABEZA, PECHO, PIERNAS, PIES }

@export_group("Estadísticas de Armadura")
@export var tipo_material: TipoArmadura = TipoArmadura.TELA
@export var slot: SlotArmadura = SlotArmadura.PECHO

@export_subgroup("Resistencias")
@export_range(0, 100) var resistencia_fuego: float = 0.0
@export_range(0, 100) var resistencia_hielo: float = 0.0
@export_range(0, 100) var resistencia_veneno: float = 0.0

func _init():
	super._init()
	tipo_equipo = TipoEquipo.ARMADURA
