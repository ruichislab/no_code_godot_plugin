# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteEfectos.gd
## Gestor avanzado de efectos de estado (Buffs/Debuffs) con soporte visual.
##
## **Uso:** Añadir a cualquier entidad que pueda ser afectada (Jugador, Enemigo).
## Requiere el uso de recursos que extiendan de `RL_StatusEffect`.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_StatusEffects
extends Node

# --- SEÑALES ---
signal efecto_aplicado(efecto: Resource) # Tipo Resource para flexibilidad, idealmente RL_StatusEffect
signal efecto_removido(efecto: Resource)
signal efecto_tick(efecto: Resource)

# --- CONFIGURACIÓN ---
@export var habilitado: bool = true

# --- ESTADO ---
# Diccionario: { "id_efecto": { "recurso": Resource, "tiempo": float, "stacks": int, "fx_node": Node } }
var efectos_activos: Dictionary = {}

func _process(delta: float) -> void:
	if not habilitado: return

	var ids_a_borrar: Array = []
	
	for id in efectos_activos:
		var datos = efectos_activos[id]
		var efecto = datos.recurso
		
		# Ejecutar lógica frame a frame (si el recurso lo define)
		if efecto.has_method("al_actualizar"):
			efecto.al_actualizar(get_parent(), delta)

		# Gestión de duración
		if efecto.get("duracion") and efecto.duracion > 0:
			datos.tiempo -= delta
			if datos.tiempo <= 0:
				ids_a_borrar.append(id)

	for id in ids_a_borrar:
		remover_efecto(id)

## Aplica un nuevo efecto a la entidad.
func aplicar_efecto(nuevo_efecto: Resource) -> void:
	if not habilitado or not nuevo_efecto: return
	
	# Validación básica de tipo (Duck typing o check de propiedad)
	if not "id_efecto" in nuevo_efecto:
		push_error("RL_StatusEffects: El recurso pasado no parece ser un efecto válido (falta id_efecto).")
		return

	var id = nuevo_efecto.id_efecto
	
	if efectos_activos.has(id):
		# --- YA EXISTE: Refrescar o Acumular ---
		var datos = efectos_activos[id]
		datos.tiempo = nuevo_efecto.duracion # Refrescar tiempo siempre
		
		var max_stacks = nuevo_efecto.get("max_acumulaciones") if "max_acumulaciones" in nuevo_efecto else 1
		if datos.stacks < max_stacks:
			datos.stacks += 1
			# print("Efecto %s acumulado: %d" % [nuevo_efecto.nombre, datos.stacks])

			# Notificar stack up
			if nuevo_efecto.has_method("al_acumular"):
				nuevo_efecto.al_acumular(get_parent(), datos.stacks)
	else:
		# --- NUEVO EFECTO ---
		var fx_node: Node = null

		# Instanciar visuales si existen
		if "efecto_visual" in nuevo_efecto and nuevo_efecto.efecto_visual:
			fx_node = nuevo_efecto.efecto_visual.instantiate()
			get_parent().add_child(fx_node)

		efectos_activos[id] = {
			"recurso": nuevo_efecto,
			"tiempo": nuevo_efecto.duracion,
			"stacks": 1,
			"fx_node": fx_node
		}

		if nuevo_efecto.has_method("al_aplicar"):
			nuevo_efecto.al_aplicar(get_parent())

		emit_signal("efecto_aplicado", nuevo_efecto)
		# print("Efecto aplicado: " + nuevo_efecto.get("nombre", id))

## Remueve un efecto forzosamente o por tiempo.
func remover_efecto(id_efecto: String) -> void:
	if efectos_activos.has(id_efecto):
		var datos = efectos_activos[id_efecto]
		var efecto = datos.recurso

		if efecto.has_method("al_remover"):
			efecto.al_remover(get_parent())

		# Limpiar visuales
		if is_instance_valid(datos.fx_node):
			datos.fx_node.queue_free()

		efectos_activos.erase(id_efecto)
		emit_signal("efecto_removido", efecto)

## Limpia todos los efectos (útil al morir o respawnear).
func limpiar_todo() -> void:
	var keys = efectos_activos.keys()
	for k in keys:
		remover_efecto(k)
