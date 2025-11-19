# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCameraZone.gd
## Zona que cambia los límites de la cámara.
##
## **Uso:** Añade este componente para definir límites de cámara por zona.
## Útil para habitaciones y áreas específicas.
##
## **Casos de uso:**
## - Habitaciones individuales
## - Arenas de combate
## - Zonas de puzzle
## - Salas de jefes
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteCameraZone
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var velocidad_transicion: float = 5.0
@export var zoom_objetivo: Vector2 = Vector2(1, 1)

var collision_shape: CollisionShape2D
var limites: Rect2

func _ready():
	# Obtener el rectángulo de la colisión
	for child in get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			collision_shape = child
			var rect = child.shape as RectangleShape2D
			var pos = child.global_position
			limites = Rect2(pos - rect.size / 2, rect.size)
			break
			
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		activar_zona()

func _on_body_exited(body):
	if body.is_in_group("jugador") or body.name == "Jugador":
		desactivar_zona()

func activar_zona():
	var cam = get_viewport().get_camera_2d()
	if cam:
		# Establecer límites
		cam.limit_left = int(limites.position.x)
		cam.limit_top = int(limites.position.y)
		cam.limit_right = int(limites.end.x)
		cam.limit_bottom = int(limites.end.y)
		
		# Opcional: Cambiar zoom suavemente (requeriría lógica en _process de la cámara o un Tween aquí)
		if zoom_objetivo != cam.zoom:
			var tween = create_tween()
			tween.tween_property(cam, "zoom", zoom_objetivo, 1.0 / velocidad_transicion)

func desactivar_zona():
	# Al salir, ¿liberamos la cámara?
	# En Metroidvanias, normalmente entras a OTRA zona inmediatamente.
	# Si sales al "vacío", podríamos resetear límites a valores gigantes.
	pass
