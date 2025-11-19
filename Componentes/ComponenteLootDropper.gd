
# Archivo: Componentes/ComponenteLootDropper.gd
## Suelta items al morir.
##
## **Uso:** Añade este componente a enemigos para que suelten botín al morir.
## Usa tablas de loot con probabilidades configurables.
##
## **Casos de uso:**
## - Drops de enemigos
## - Recompensas de jefes
## - Piñatas
## - Cajas destructibles
##
## **Nota:** Escucha la señal 'muerte' del nodo padre.
@icon("res://icon.svg")
class_name ComponenteLootDropper
extends Node
const _tool_context = "RuichisLab/Nodos"

# Este componente escucha la muerte de su padre y suelta objetos.

## Recurso Tabla de Loot con las probabilidades.
@export var tabla_loot: RecursoTablaLoot
## Probabilidad global de soltar algo (0.0 a 1.0).
@export var probabilidad_global: float = 1.0

func _ready():
	# Intentar conectar automáticamente si el padre tiene señal de muerte
	# Asumimos que usamos el EventBus o una señal local 'muerto'
	var padre = get_parent()
	
	# Opción A: Conectarse al EventBus (Más desacoplado)
	if EventBus:
		EventBus.entidad_murio.connect(_on_entidad_murio)
		
	# Opción B: Conectarse a señal local (si existe)
	if padre.has_signal("muerto"):
		padre.connect("muerto", soltar_loot)

func _on_entidad_murio(entidad):
	if entidad == get_parent():
		soltar_loot()

func soltar_loot():
	if not tabla_loot: return
	if randf() > probabilidad_global: return
	
	var item = tabla_loot.obtener_drop()
	if item:
		spawnear_item_en_mundo(item)

func spawnear_item_en_mundo(item: RecursoObjeto):
	print("Loot soltado: " + item.nombre)
	
	# Aquí instanciaríamos una escena "ItemPickup" visual.
	# Como no tenemos esa escena aún, crearemos un placeholder o usaremos un Sprite simple.
	# En un proyecto real, deberías tener una escena 'ItemWorld.tscn'.
	
	var sprite = Sprite2D.new()
	# Cargar textura si existe, sino usar un color
	if item.ruta_icono and ResourceLoader.exists(item.ruta_icono):
		sprite.texture = load(item.ruta_icono)
	else:
		# Placeholder visual
		var placeholder = PlaceholderTexture2D.new()
		placeholder.size = Vector2(16, 16)
		sprite.texture = placeholder
		
	sprite.global_position = get_parent().global_position
	get_tree().current_scene.call_deferred("add_child", sprite)
	
	# Animación de "salto"
	var tween = create_tween()
	var destino = sprite.global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20))
	tween.tween_property(sprite, "global_position", destino, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# TODO: Añadir ComponenteInteraccion a este sprite para poder recogerlo
