# Archivo: Datos/Inventario/RecursoEquipable.gd
class_name RecursoEquipable
extends RecursoObjeto

enum TipoEquipo { ARMA, ARMADURA, ACCESORIO }

@export_group("Datos de Equipo")
@export var tipo_equipo: TipoEquipo = TipoEquipo.ARMA
@export var ataque_bonus: float = 0.0
@export var defensa_bonus: float = 0.0

func _init():
	es_consumible = false
	es_apilable = false
	tipo_objeto = "equipo"

func usar(jugador: Node) -> bool:
	# La lógica de "usar" un equipo suele ser "equiparlo".
	# Esto requeriría un sistema de equipamiento en el jugador.
	print("Intentando equipar: " + nombre)
	
	# TODO: Implementar sistema de equipamiento
	# var equipo_manager = jugador.get_node("EquipoManager")
	# if equipo_manager:
	# 	equipo_manager.equipar(self)
	# 	return false # No se consume, se mueve al slot de equipo
	
	return false
