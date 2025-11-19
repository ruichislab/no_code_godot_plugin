# Archivo: Servicios/PoolManager.gd
extends Node

# Configurar como Autoload: "PoolManager"
# Sistema de Object Pooling para optimizar rendimiento en cualquier tipo de juego.

var pools: Dictionary = {} # { "id_pool": { "escena": PackedScene, "inactivos": [] } }
var nodo_contenedor: Node

func _ready():
	nodo_contenedor = Node.new()
	nodo_contenedor.name = "PoolContainer"
	add_child(nodo_contenedor)

# Registra una escena para ser pooleada
func registrar_pool(id: String, escena: PackedScene, cantidad_inicial: int = 10):
	if pools.has(id): return
	
	pools[id] = {
		"escena": escena,
		"inactivos": []
	}
	
	# Pre-instanciar
	for i in range(cantidad_inicial):
		var obj = escena.instantiate()
		obj.visible = false
		obj.process_mode = Node.PROCESS_MODE_DISABLED
		nodo_contenedor.add_child(obj)
		pools[id].inactivos.append(obj)

# Obtiene un objeto del pool (o crea uno nuevo si está vacío)
func spawn(id: String, posicion: Vector2, rotacion: float = 0.0, padre: Node = null) -> Node:
	if not pools.has(id):
		push_error("PoolManager: Pool '%s' no registrado." % id)
		return null
		
	var obj: Node
	var pool = pools[id]
	
	if pool.inactivos.size() > 0:
		obj = pool.inactivos.pop_back()
	else:
		# Pool vacío, crear nuevo (expandir pool)
		obj = pool.escena.instantiate()
	
	# Configurar objeto
	if padre:
		if obj.get_parent(): obj.get_parent().remove_child(obj)
		padre.add_child(obj)
	else:
		if obj.get_parent() != get_tree().current_scene:
			if obj.get_parent(): obj.get_parent().remove_child(obj)
			get_tree().current_scene.add_child(obj)
			
	if obj is Node2D:
		obj.global_position = posicion
		obj.rotation = rotacion
		
	obj.visible = true
	obj.process_mode = Node.PROCESS_MODE_INHERIT
	
	# Si el objeto tiene un método 'on_spawn', lo llamamos
	if obj.has_method("on_spawn"):
		obj.on_spawn()
		
	return obj

# Devuelve un objeto al pool (en lugar de queue_free)
func despawn(id: String, objeto: Node):
	if not pools.has(id): return
	
	# Resetear
	objeto.visible = false
	objeto.process_mode = Node.PROCESS_MODE_DISABLED
	
	if objeto.get_parent() != nodo_contenedor:
		objeto.get_parent().remove_child(objeto)
		nodo_contenedor.add_child(objeto)
		
	pools[id].inactivos.append(objeto)
