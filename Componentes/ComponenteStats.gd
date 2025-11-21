# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteStats.gd
## Gestor de Atributos (Salud, Mana, Fuerza, etc.) con sistema de modificadores.
##
## **Uso:** Añadir al Jugador o Enemigos. Centraliza la lógica de RPG.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Stats
extends Node

# --- SEÑALES ---
signal salud_cambiada(actual: float, maximo: float)
signal mana_cambiado(actual: float, maximo: float)
signal atributo_cambiado(nombre: String, valor: float)
signal muerte

# --- CONFIGURACIÓN ---
@export var stats_base: ResourceStats

# --- ESTADO ---
# Diccionario de valores actuales (base + modificadores)
var _atributos: Dictionary = {}
# Diccionario de modificadores: { "fuerza": [ { "id": "buff_pocion", "valor": 10, "tipo": "add" } ] }
var _modificadores: Dictionary = {}

var salud_actual: float
var mana_actual: float

func _ready() -> void:
	if stats_base:
		_inicializar_desde_recurso()
	else:
		# Valores por defecto si no hay recurso
		_atributos["salud_maxima"] = 100.0
		_atributos["mana_maximo"] = 50.0
		_atributos["ataque"] = 10.0
		_atributos["defensa"] = 0.0
		salud_actual = 100.0
		mana_actual = 50.0

func _inicializar_desde_recurso() -> void:
	_atributos["salud_maxima"] = stats_base.salud_maxima
	_atributos["mana_maximo"] = stats_base.mana_maximo
	_atributos["ataque"] = stats_base.ataque
	_atributos["defensa"] = stats_base.defensa
	_atributos["velocidad"] = stats_base.velocidad

	salud_actual = stats_base.salud_maxima
	mana_actual = stats_base.mana_maximo

# --- API PÚBLICA ---

func obtener_valor(nombre_atributo: String) -> float:
	return _atributos.get(nombre_atributo, 0.0)

func aplicar_dano(cantidad: float) -> void:
	var defensa = obtener_valor("defensa")
	# Fórmula simple de reducción: Daño - Defensa (min 1)
	var dano_final = max(1.0, cantidad - defensa)

	salud_actual = max(0.0, salud_actual - dano_final)
	emit_signal("salud_cambiada", salud_actual, obtener_valor("salud_maxima"))

	# Feedback visual automático
	if Engine.has_singleton("FloatingTextManager"):
		Engine.get_singleton("FloatingTextManager").call("mostrar_valor", str(int(dano_final)), get_parent().global_position, "dano")

	if salud_actual <= 0:
		emit_signal("muerte")

func curar(cantidad: float) -> void:
	var max_hp = obtener_valor("salud_maxima")
	salud_actual = min(max_hp, salud_actual + cantidad)
	emit_signal("salud_cambiada", salud_actual, max_hp)

	if Engine.has_singleton("FloatingTextManager"):
		Engine.get_singleton("FloatingTextManager").call("mostrar_valor", str(int(cantidad)), get_parent().global_position, "curacion")

func curar_completo() -> void:
	curar(obtener_valor("salud_maxima"))

## Añade un modificador a un atributo (ej: "ataque", +10).
## `tipo`: "add" (suma) o "mult" (multiplica).
func agregar_modificador(atributo: String, id_mod: String, valor: float, tipo: String = "add") -> void:
	if not _modificadores.has(atributo):
		_modificadores[atributo] = []

	_modificadores[atributo].append({ "id": id_mod, "valor": valor, "tipo": tipo })
	_recalcular_atributo(atributo)

func remover_modificador(atributo: String, id_mod: String) -> void:
	if not _modificadores.has(atributo): return

	var lista = _modificadores[atributo]
	for i in range(lista.size() - 1, -1, -1):
		if lista[i].id == id_mod:
			lista.remove_at(i)

	_recalcular_atributo(atributo)

# --- INTERNO ---

func _recalcular_atributo(nombre: String) -> void:
	if not stats_base: return

	var base = stats_base.get(nombre) if nombre in stats_base else 0.0
	var valor_final = base

	if _modificadores.has(nombre):
		for mod in _modificadores[nombre]:
			if mod.tipo == "add":
				valor_final += mod.valor
			elif mod.tipo == "mult":
				valor_final *= mod.valor

	_atributos[nombre] = valor_final
	emit_signal("atributo_cambiado", nombre, valor_final)

	# Casos especiales
	if nombre == "salud_maxima":
		emit_signal("salud_cambiada", salud_actual, valor_final)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not stats_base:
		warnings.append("Se recomienda asignar un 'ResourceStats' base.")
	return warnings
