# Archivo: addons/no_code_godot_plugin/Autoloads/PoolManager.gd
## Manager global para pooling de objetos.
##
## **Uso:** Autoload automático. Úsalo con `PoolManager.spawn()`.
##
## **Funciones:**
## - Reutilización de objetos para optimizar rendimiento
## - Spawn/despawn de enemigos, proyectiles, etc.
## - Configuración de pools por ID

extends Node

var pools: Dictionary = {} # id -> {scene: PackedScene, instances: Array}

## Registra una nueva pool con un ID y una escena.
func registrar_pool(id: String, escena: PackedScene, cantidad_inicial: int = 10):
	if pools.has(id):
		push_warning("PoolManager: Pool '", id, "' ya existe, se sobrescribirá")
	
	pools[id] = {
		"scene": escena,
		"instances": []
	}
	
	# Pre-instanciar objetos
	for i in cantidad_inicial:
		var obj = escena.instantiate()
		obj.set_meta("pool_id", id)
		obj.process_mode = Node.PROCESS_MODE_DISABLED
		obj.hide()
		add_child(obj)
		pools[id]["instances"].append(obj)
	
	print("PoolManager: Pool '", id, "' registrada con ", cantidad_inicial, " instancias")

## Obtiene un objeto de la pool (spawn).
func spawn(id: String, posicion: Vector2 = Vector2.ZERO, rotacion: float = 0.0) -> Node:
	if not pools.has(id):
		push_error("PoolManager: Pool '", id, "' no existe. Regístrala primero.")
		return null
	
	var pool = pools[id]
	var obj: Node = null
	
	# Buscar instancia disponible
	for inst in pool["instances"]:
		if inst.process_mode == Node.PROCESS_MODE_DISABLED:
			obj = inst
			break
	
	# Si no hay disponible, crear una nueva
	if obj == null:
		obj = pool["scene"].instantiate()
		obj.set_meta("pool_id", id)
		add_child(obj)
		pool["instances"].append(obj)
		print("PoolManager: Pool '", id, "' expandida")
	
	# Activar objeto
	obj.process_mode = Node.PROCESS_MODE_INHERIT
	obj.show()
	
	if obj is Node2D:
		obj.global_position = posicion
		obj.rotation = rotacion
	elif obj is Node3D:
		obj.global_position = Vector3(posicion.x, 0, posicion.y)
		obj.rotation.y = rotacion
	
	# Llamar método de inicialización si existe
	if obj.has_method("_on_spawn"):
		obj._on_spawn()
	
	return obj

## Devuelve un objeto a la pool (despawn).
func despawn(obj: Node):
	if not obj.has_meta("pool_id"):
		push_warning("PoolManager: El objeto no pertenece a ninguna pool")
		return
	
	# Llamar método de limpieza si existe
	if obj.has_method("_on_despawn"):
		obj._on_despawn()
	
	obj.process_mode = Node.PROCESS_MODE_DISABLED
	obj.hide()
	
	if obj is Node2D:
		obj.global_position = Vector2.ZERO
	elif obj is Node3D:
		obj.global_position = Vector3.ZERO

## Limpia una pool específica.
func limpiar_pool(id: String):
	if not pools.has(id):
		return
	
	for inst in pools[id]["instances"]:
		inst.queue_free()
	
	pools[id]["instances"].clear()
	print("PoolManager: Pool '", id, "' limpiada")

## Limpia todas las pools.
func limpiar_todas():
	for id in pools.keys():
		limpiar_pool(id)
