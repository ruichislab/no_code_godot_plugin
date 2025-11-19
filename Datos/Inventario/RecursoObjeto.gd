# Archivo: Datos/Inventario/RecursoObjeto.gd
extends Resource
class_name RecursoObjeto

# NOTA: Heredar de Resource permite guardar la información como archivos .tres

# --- PROPIEDADES BASE ---

@export var id_unico: String = "" # Identificador interno (ej: "pocion_salud")
@export var nombre: String = "Objeto Desconocido" # Nombre que ve el jugador
@export var descripcion: String = "Una descripción corta del objeto."
@export var ruta_icono: String = "" # Ruta a la textura del icono (ej: "res://Assets/Iconos/pocion.png")

# --- PROPIEDADES DE INVENTARIO ---

@export var es_apilable: bool = false # ¿Se puede apilar? (True para pociones, False para espadas únicas)
@export var cantidad_maxima: int = 1 # Máximo de unidades por stack (si es apilable)

# Si tienes tipos, es mejor definir una lista de ENUM, pero por ahora usamos String:
@export var tipo_objeto: String = "general" # Ej: "arma", "armadura", "pocion", "material"

# --- PROPIEDADES DE USO ---

@export var es_consumible: bool = false # ¿Desaparece al usar?


# --- MÉTODOS BASE ---

# Función que se llama cuando el jugador intenta usar el objeto.
# Retorna 'true' si el objeto debe ser consumido (eliminado del inventario).
# Debe ser sobreescrita por clases específicas (ej: Consumible.gd)
func usar(jugador: Node) -> bool:
	print("Usando objeto base: " + nombre)
	if es_consumible:
		# Si el objeto base es consumible, se marcará para ser eliminado.
		return true
	
	return false
