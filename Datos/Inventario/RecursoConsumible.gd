# Archivo: Datos/Inventario/RecursoConsumible.gd
class_name RecursoConsumible
extends RecursoObjeto

@export_group("Efectos de Consumo")
@export var salud_recuperada: float = 0.0
@export var mana_recuperado: float = 0.0
# @export var buff_temporal: RecursoBuff # Futura expansión

func _init():
	es_consumible = true
	es_apilable = true
	tipo_objeto = "consumible"

func usar(jugador: Node) -> bool:
	# Intentamos obtener el componente de estadísticas del jugador
	var estadisticas = jugador.get_node_or_null("Estadisticas")
	
	if not estadisticas:
		print("Error: El jugador no tiene nodo Estadisticas.")
		return false
		
	var se_uso = false
	
	if salud_recuperada > 0:
		estadisticas.sanar(salud_recuperada)
		se_uso = true
		print("Consumido %s: Recuperada %f salud." % [nombre, salud_recuperada])

	# Aquí añadiríamos lógica para maná, etc.
	
	return se_uso
