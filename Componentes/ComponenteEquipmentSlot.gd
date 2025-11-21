# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteEquipmentSlot.gd
## Slot de equipamiento que modifica stats automáticamente.
##
## **Uso:** Inventario de equipo. Al asignar un item, actualiza el `RL_Stats` vinculado.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_EquipmentSlot
extends Node

# --- CONFIGURACIÓN ---
@export_enum("Arma", "Casco", "Armadura", "Botas", "Accesorio") var tipo_slot: int = 0
@export var nodo_stats: RL_Stats

# --- ESTADO ---
var item_equipado: RL_RecursoEquipo

func equipar(item: RL_RecursoEquipo) -> bool:
	if not item or item.tipo_slot != tipo_slot:
		push_warning("RL_EquipmentSlot: Tipo de item incorrecto.")
		return false

	if item_equipado:
		desequipar()

	item_equipado = item
	_aplicar_modificadores(item, false) # false = agregar
	print("Equipado: " + item.nombre)
	return true

func desequipar() -> void:
	if not item_equipado: return

	_aplicar_modificadores(item_equipado, true) # true = remover
	print("Desequipado: " + item_equipado.nombre)
	item_equipado = null

func _aplicar_modificadores(item: RL_RecursoEquipo, remover: bool) -> void:
	if not nodo_stats: return

	for stat_name in item.modificadores:
		var valor = item.modificadores[stat_name]
		var id_mod = "equipo_" + str(tipo_slot)

		if remover:
			nodo_stats.remover_modificador(stat_name, id_mod)
		else:
			nodo_stats.agregar_modificador(stat_name, id_mod, valor, "add")

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not nodo_stats:
		warnings.append("Asigna un componente 'RL_Stats' para aplicar los efectos.")
	return warnings
