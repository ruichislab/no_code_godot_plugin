# Archivo: Datos/Loot/RecursoTablaLoot.gd
class_name RecursoTablaLoot
extends Resource

# Estructura simple: Item + Probabilidad (0.0 a 1.0)
# Para hacerlo más visual en el editor, podríamos usar un recurso intermedio "LootEntry",
# pero usaremos Arrays paralelos por simplicidad.

@export var items: Array[RecursoObjeto] = []
@export var probabilidades: Array[float] = [] # 0.5 = 50%

func obtener_drop() -> RecursoObjeto:
	var roll = randf() # 0.0 a 1.0
	var acumulado = 0.0
	
	for i in range(items.size()):
		if i >= probabilidades.size(): break
		
		acumulado += probabilidades[i]
		if roll <= acumulado:
			return items[i]
			
	return null # No drop
