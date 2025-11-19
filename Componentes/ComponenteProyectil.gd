# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteProyectil.gd
## Proyectil que se mueve y causa daño.
##
## **Uso:** Añade este componente a balas, flechas, bolas de fuego, etc.
## Se mueve automáticamente y se destruye al impactar.
##
## **Casos de uso:**
## - Balas de pistola
## - Flechas
## - Bolas de fuego
## - Misiles
## - Shuriken
##
## **Requisito:** Debe tener un hijo Hitbox.
@icon("res://icon.svg")
class_name ComponenteProyectil
extends Node
const _tool_context = "RuichisLab/Nodos"

# Lógica básica para proyectiles (balas, bolas de fuego).
# Mueve al padre hacia adelante y gestiona su vida útil.

## Velocidad de movimiento.
@export var velocidad: float = 400.0
## Tiempo en segundos antes de desaparecer.
@export var tiempo_vida: float = 3.0
## Si es true, se destruye al tocar algo.
@export var destruir_al_impactar: bool = true
## Escena opcional para instanciar al impactar (explosión).
@export var efecto_impacto: PackedScene

var padre: Node2D

func _ready():
	padre = get_parent() as Node2D
	if not padre: return
	
	# Timer de vida
	await get_tree().create_timer(tiempo_vida).timeout
	if is_instance_valid(padre):
		padre.queue_free()

func _physics_process(delta):
	if not padre: return
	
	# Mover hacia la derecha relativa (transform.x)
	padre.position += Vector2.RIGHT.rotated(padre.rotation) * velocidad * delta

# Conectar esto a la señal "area_entered" o "body_entered" del Hitbox/Area2D del padre
func al_impactar(algo):
	if efecto_impacto:
		var fx = efecto_impacto.instantiate()
		fx.global_position = padre.global_position
		fx.rotation = padre.rotation
		get_tree().current_scene.add_child(fx)
		
	if destruir_al_impactar:
		padre.queue_free()
