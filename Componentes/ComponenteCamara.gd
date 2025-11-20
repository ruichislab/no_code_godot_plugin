# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd
## Cámara avanzada con efectos de "Game Feel" (Temblor, Suavizado, Anticipación).
##
## **Características:**
## - Temblor (Screen Shake) basado en "trauma".
## - Seguimiento suave.
## - Anticipación (Lookahead): La cámara mira hacia donde te mueves.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_JuicyCamera
extends Camera2D

# --- CONFIGURACIÓN ---

## Nodo objetivo a seguir.
@export var objetivo: Node2D

## Velocidad de suavizado.
@export var velocidad_suavizado: float = 5.0

@export_group("Anticipación (Look Ahead)")
## Si es true, la cámara se adelanta.
@export var usar_anticipacion: bool = true
## Distancia máxima de anticipación.
@export var distancia_anticipacion: float = 100.0
## Velocidad de ajuste.
@export var velocidad_anticipacion: float = 2.0

@export_group("Temblor (Screen Shake)")
## Velocidad a la que el temblor desaparece.
@export var decaimiento_trauma: float = 2.0
## Desplazamiento máximo (intensidad).
@export var desplazamiento_max: Vector2 = Vector2(20, 20)
## Rotación máxima.
@export var rotacion_max: float = 0.1
## Ruido para movimiento aleatorio.
@export var ruido: FastNoiseLite

# --- ESTADO ---
var trauma: float = 0.0
var _offset_anticipacion: Vector2 = Vector2.ZERO
var _tiempo_ruido: float = 0.0

func _ready() -> void:
	if not objetivo:
		if get_parent() is Node2D:
			objetivo = get_parent()
			top_level = true

	if Engine.has_singleton("EventBus"):
		var bus = Engine.get_singleton("EventBus")
		if bus.has_signal("evento_global"):
			bus.connect("evento_global", _on_evento_global_generico)

func _process(delta: float) -> void:
	if objetivo:
		var pos_objetivo = objetivo.global_position

		# Anticipación
		if usar_anticipacion:
			var velocidad = Vector2.ZERO
			if objetivo is CharacterBody2D:
				velocidad = objetivo.velocity
			elif "velocity" in objetivo:
				velocidad = objetivo.velocity

			var objetivo_anticipacion = Vector2.ZERO
			if velocidad.length() > 10:
				objetivo_anticipacion = velocidad.normalized() * distancia_anticipacion

			_offset_anticipacion = _offset_anticipacion.lerp(objetivo_anticipacion, velocidad_anticipacion * delta)
			pos_objetivo += _offset_anticipacion

		global_position = global_position.lerp(pos_objetivo, velocidad_suavizado * delta)

	# Temblor
	if trauma > 0:
		trauma = max(trauma - decaimiento_trauma * delta, 0)
		_aplicar_temblor(delta)
	elif offset != Vector2.ZERO or rotation != 0:
		offset = offset.lerp(Vector2.ZERO, 10 * delta)
		rotation = lerp(rotation, 0.0, 10 * delta)

func _aplicar_temblor(delta: float) -> void:
	var cantidad = trauma * trauma
	_tiempo_ruido += delta * 30.0

	if ruido:
		offset.x = desplazamiento_max.x * cantidad * ruido.get_noise_2d(_tiempo_ruido, 0)
		offset.y = desplazamiento_max.y * cantidad * ruido.get_noise_2d(0, _tiempo_ruido)
		rotation = rotacion_max * cantidad * ruido.get_noise_2d(_tiempo_ruido, _tiempo_ruido)
	else:
		offset.x = desplazamiento_max.x * cantidad * randf_range(-1, 1)
		offset.y = desplazamiento_max.y * cantidad * randf_range(-1, 1)
		rotation = rotacion_max * cantidad * randf_range(-1, 1)

## Añade trauma (0.0 a 1.0).
func agregar_trauma(cantidad: float) -> void:
	trauma = min(trauma + cantidad, 1.0)

func _on_evento_global_generico(nombre: String, datos: Dictionary) -> void:
	if nombre == "temblor" or nombre == "shake":
		var fuerza = datos.get("fuerza", 0.5)
		agregar_trauma(fuerza)
