# Archivo: addons/no_code_godot_plugin/Autoloads/PoolManager.gd
## Gestor de Reciclaje de Objetos (Object Pooling).
##
## **Uso:** `PoolManager.instanciar(id, pos)` / `PoolManager.reciclar(obj)`.
extends Node

# Diccionario: { "id_pool": { "escena": PackedScene, "inactivos": Array[Node], "padre": Node } }
var _piscinas: Dictionary = {}

## Registra una nueva piscina de objetos.
func registrar_piscina(id: String, escena: PackedScene, precalentar: int = 10, padre_opcional: Node = null) -> void:
	if _piscinas.has(id):
		push_warning("PoolManager: Piscina '%s' ya existe." % id)
		return

	var contenedor = padre_opcional if padre_opcional else self
	
	_piscinas[id] = {
		"escena": escena,
		"inactivos": [],
		"padre": contenedor
	}
	
	for i in range(precalentar):
		var inst = _crear_nueva_instancia(id, escena)
		_desactivar_instancia(inst, id)

## Obtiene una instancia activa (Spawn).
func instanciar(id: String, pos_global: Variant = null, rotacion: float = 0.0) -> Node:
	if not _piscinas.has(id):
		push_error("PoolManager: Piscina '%s' no registrada." % id)
		return null

	var datos_pool = _piscinas[id]
	var obj: Node
	
	if datos_pool.inactivos.is_empty():
		obj = _crear_nueva_instancia(id, datos_pool.escena)
	else:
		obj = datos_pool.inactivos.pop_back()
	
	if obj.get_parent() != datos_pool.padre:
		if obj.get_parent(): obj.get_parent().remove_child(obj)
		datos_pool.padre.add_child(obj)
	
	_activar_instancia(obj, pos_global, rotacion)
	return obj

## Devuelve el objeto a la piscina (Despawn).
func reciclar(obj: Node) -> void:
	if not is_instance_valid(obj): return
	if not obj.has_meta("id_pool"):
		obj.queue_free()
		return

	var id = obj.get_meta("id_pool")
	if not _piscinas.has(id):
		obj.queue_free()
		return

	_desactivar_instancia(obj, id)

# --- INTERNO ---

func _crear_nueva_instancia(id: String, escena: PackedScene) -> Node:
	var obj = escena.instantiate()
	obj.set_meta("id_pool", id)
	_piscinas[id].padre.add_child(obj)
	return obj

func _activar_instancia(obj: Node, pos: Variant, rot: float) -> void:
	obj.process_mode = Node.PROCESS_MODE_INHERIT
	obj.visible = true
	
	if obj is Node2D:
		if pos != null: obj.global_position = pos
		obj.rotation = rot
	elif obj is Node3D:
		if pos != null and pos is Vector3: obj.global_position = pos
		obj.rotation.y = rot

	if obj.has_method("_al_instanciar"):
		obj._al_instanciar()
	elif obj.has_method("_on_spawn"): # Compatibilidad
		obj._on_spawn()

	if obj is CPUParticles2D or obj is GPUParticles2D:
		obj.restart()

func _desactivar_instancia(obj: Node, id: String) -> void:
	if obj.has_method("_al_reciclar"):
		obj._al_reciclar()
	elif obj.has_method("_on_despawn"):
		obj._on_despawn()

	obj.process_mode = Node.PROCESS_MODE_DISABLED
	obj.visible = false
	
	if obj is Node2D: obj.position = Vector2(-9999, -9999)
	
	_piscinas[id].inactivos.append(obj)

func limpiar_todo() -> void:
	for id in _piscinas:
		var pool = _piscinas[id]
		for obj in pool.inactivos:
			if is_instance_valid(obj): obj.queue_free()
		pool.inactivos.clear()
	_piscinas.clear()
