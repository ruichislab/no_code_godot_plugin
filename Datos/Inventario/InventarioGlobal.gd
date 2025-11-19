# Archivo: Datos/Inventario/InventarioGlobal.gd
extends Node
# ¡IMPORTANTE! Configurar como 'Autoload' en el Proyecto > Ajustes del Proyecto

# --- ESTRUCTURAS DE DATOS ---

# Inventario principal basado en slots (Array de Diccionarios)
# Almacena objetos únicos y aquellos con propiedades dinámicas (durabilidad, etc.)
var inventario_principal: Array = []
const MAX_SLOTS: int = 24 

# Almacén de recursos apilables (Diccionario: id_unico -> cantidad)
# Almacena materiales, monedas y otros objetos que solo necesitan cantidad.
var recursos: Dictionary = {
	"moneda_oro": 0,
	"madera_roble": 0,
}

# --- INICIALIZACIÓN ---

func _ready():
	# Inicializa el array principal con slots vacíos
	for i in range(MAX_SLOTS):
		inventario_principal.append({}) # {} representa un slot vacío
	print("Inventario Global inicializado con %d slots." % MAX_SLOTS)

# --- BASE DE DATOS ESTATICA (Simulación de carga) ---

# Función de marcador: En un juego real, aquí cargarías una base de datos grande.
# Por ahora, carga el recurso .tres directamente.
func obtener_datos_estaticos(id_objeto: String) -> RecursoObjeto:
	var ruta = "res://Datos/Inventario/recursos_estaticos/%s.tres" % id_objeto
	
	if ResourceLoader.exists(ruta):
		# Es crucial usar load(ruta).duplicate() para obtener una copia modificable 
		# del recurso sin modificar el archivo .tres original.
		var objeto_base = load(ruta).duplicate() as RecursoObjeto
		return objeto_base
	else:
		push_error("Error: No se encontraron los datos estáticos para ID: " + id_objeto)
		# Retorna un objeto vacío para evitar errores de tipo.
		return RecursoObjeto.new() 

# --- FUNCIONES DE GESTIÓN (AÑADIR) ---

# Función principal para añadir cualquier objeto al sistema.
func anadir_objeto(id_objeto: String, cantidad: int = 1) -> bool:
	if cantidad <= 0: return false
	
	var datos_base: RecursoObjeto = obtener_datos_estaticos(id_objeto) 

	if datos_base.tipo_objeto == "material":
		# Los materiales van directamente al diccionario de recursos.
		return anadir_recurso(id_objeto, cantidad)
	
	# Objetos no-materiales (armas, pociones, etc.) van al array principal.
	return anadir_a_slot(id_objeto, cantidad)


# Añade recursos (monedas, maderas) al diccionario de recursos.
func anadir_recurso(id_recurso: String, cantidad: int) -> bool:
	if not recursos.has(id_recurso):
		recursos[id_recurso] = 0
	
	recursos[id_recurso] += cantidad
	print("Añadido %d de %s. Total: %d" % [cantidad, id_recurso, recursos[id_recurso]])
	# Señal para actualizar la UI de recursos (ej: monedas)
	emit_signal("recursos_actualizados", id_recurso, recursos[id_recurso])
	return true


# Añade objetos al array principal, manejando apilamiento y slots vacíos.
func anadir_a_slot(id_objeto: String, cantidad_a_anadir: int) -> bool:
	var datos_base: RecursoObjeto = obtener_datos_estaticos(id_objeto)
	var cantidad_pendiente = cantidad_a_anadir

	# 1. Intentar apilar en slots existentes
	if datos_base.es_apilable:
		cantidad_pendiente = intentar_apilar(id_objeto, cantidad_a_anadir, datos_base.cantidad_maxima)

	# 2. Añadir lo restante en nuevos slots completamente vacíos
	if cantidad_pendiente > 0:
		cantidad_pendiente = colocar_en_slots_vacios(id_objeto, cantidad_pendiente, datos_base)
	
	# Señal para actualizar la UI del inventario principal
	emit_signal("inventario_actualizado") 

	if cantidad_pendiente == 0:
		return true
	else:
		push_error("Inventario lleno. No se pudo añadir %d de %s." % [cantidad_pendiente, datos_base.nombre])
		return false

# --- FUNCIONES DE SOPORTE PARA ANADIR_A_SLOT ---

# Intenta llenar los stacks existentes en el inventario
func intentar_apilar(id: String, a_anadir: int, max_stack: int) -> int:
	var restante = a_anadir
	
	for i in range(inventario_principal.size()):
		var slot = inventario_principal[i]
		
		# Comprueba si el slot tiene el mismo objeto Y no está lleno
		if slot.has("id_unico") and slot.id_unico == id and slot.cantidad < max_stack:
			var espacio_disponible = max_stack - slot.cantidad
			var cantidad_a_mover = min(restante, espacio_disponible)
			
			slot.cantidad += cantidad_a_mover
			restante -= cantidad_a_mover
			
			if restante == 0:
				break
				
	return restante # Devuelve lo que queda pendiente

# Coloca el objeto restante en slots completamente vacíos
func colocar_en_slots_vacios(id: String, a_colocar: int, datos_base: RecursoObjeto) -> int:
	var restante = a_colocar
	var max_stack = datos_base.cantidad_maxima
	
	for i in range(inventario_principal.size()):
		if inventario_principal[i].is_empty():
			
			var cantidad_a_mover = min(restante, max_stack) 
			
			# Creación del diccionario del slot con las propiedades iniciales
			inventario_principal[i] = {
				"id_unico": id,
				"cantidad": cantidad_a_mover
				# PROPIEDADES DINÁMICAS (Ej: durabilidad, encantamientos) irían aquí
				# "durabilidad_actual": datos_base.durabilidad_maxima 
			}
			
			restante -= cantidad_a_mover
			
			if restante == 0:
				break

	return restante # Devuelve lo que no pudo entrar
	
# Elimina una cantidad específica de un objeto del inventario
func remover_objeto(id_objeto: String, cantidad: int) -> bool:
	var cantidad_a_remover = cantidad
	
	# 1. Buscar en slots (para objetos no apilables o apilables en slots)
	for i in range(inventario_principal.size()):
		var slot = inventario_principal[i]
		if not slot.is_empty() and slot.id_unico == id_objeto:
			if slot.cantidad >= cantidad_a_remover:
				slot.cantidad -= cantidad_a_remover
				cantidad_a_remover = 0
				if slot.cantidad == 0:
					inventario_principal[i] = {} # Vaciar slot
			else:
				cantidad_a_remover -= slot.cantidad
				inventario_principal[i] = {} # Vaciar slot
			
			if cantidad_a_remover == 0:
				emit_signal("inventario_actualizado")
				return true
				
	# 2. Buscar en recursos
	if recursos.has(id_objeto):
		if recursos[id_objeto] >= cantidad:
			recursos[id_objeto] -= cantidad
			emit_signal("recursos_actualizados", id_objeto, recursos[id_objeto])
			return true
			
	return false # No se encontró suficiente cantidad

# --- SEÑALES (MUY IMPORTANTES PARA LA UI) ---

signal inventario_actualizado
signal recursos_actualizados(id_recurso: String, nueva_cantidad: int)

# --- Ejemplo de uso y eliminación ---

func usar_objeto_en_slot(indice_slot: int, jugador: Node) -> bool:
	if indice_slot < 0 or indice_slot >= inventario_principal.size(): return false
	
	var slot = inventario_principal[indice_slot]
	if slot.is_empty(): return false
	
	var datos_base: RecursoObjeto = obtener_datos_estaticos(slot.id_unico)
	
	# 1. Ejecutar la función de uso
	var debe_consumirse: bool = datos_base.usar(jugador)
	
	# 2. Gestionar la eliminación/consumo si es necesario
	if debe_consumirse:
		slot.cantidad -= 1
		if slot.cantidad <= 0:
			inventario_principal[indice_slot] = {} # Vaciar el slot
		
		emit_signal("inventario_actualizado")
		return true
		
	return false # El objeto se usó, pero no se consumió (ej: una herramienta)

# --- SISTEMA DE GUARDADO ---

func guardar_datos() -> Dictionary:
	return {
		"inventario_principal": inventario_principal,
		"recursos": recursos
	}

func cargar_datos(datos: Dictionary):
	if datos.has("inventario_principal"):
		inventario_principal = datos.inventario_principal
		# Validar tamaño por si cambió la versión del juego
		if inventario_principal.size() != MAX_SLOTS:
			inventario_principal.resize(MAX_SLOTS)
			
	if datos.has("recursos"):
		recursos = datos.recursos
		
	emit_signal("inventario_actualizado")
	# Emitir señal para cada recurso podría ser costoso, mejor que la UI lea todo al cargar
