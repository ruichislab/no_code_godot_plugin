# Archivo: Servicios/VariableManager.gd
extends Node

# Configurar como Autoload: "VariableManager"
# Este sistema permite gestionar el estado del juego (Flags, Contadores) sin código.

signal variable_cambiada(nombre: String, valor_nuevo: Variant)

var variables: Dictionary = {}

func set_valor(nombre: String, valor: Variant):
	variables[nombre] = valor
	emit_signal("variable_cambiada", nombre, valor)
	print("Var '%s' = %s" % [nombre, str(valor)])

func get_valor(nombre: String, valor_por_defecto: Variant = null) -> Variant:
	return variables.get(nombre, valor_por_defecto)

func sumar_valor(nombre: String, cantidad: float):
	var actual = get_valor(nombre, 0.0)
	if actual is float or actual is int:
		set_valor(nombre, actual + cantidad)

func toggle_valor(nombre: String):
	var actual = get_valor(nombre, false)
	if actual is bool:
		set_valor(nombre, !actual)

# --- PERSISTENCIA ---
func guardar_datos() -> Dictionary:
	return variables

func cargar_datos(datos: Dictionary):
	variables = datos
