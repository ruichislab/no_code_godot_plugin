# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd
## Cámara avanzada con efectos de "Game Feel" (Screen Shake, Smooth Follow, Lookahead).
##
## **Uso:** Reemplaza la Camera2D estándar.
## **Características:**
## - Screen Shake basado en "trauma" (exponencial para mejor sensación).
## - Seguimiento suave con interpolación.
## - "Lookahead": La cámara mira un poco hacia donde se mueve el personaje.
## - Zoom dinámico.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_JuicyCamera
extends Camera2D

# --- CONFIGURACIÓN ---

## Nodo objetivo a seguir. Si vacío, intenta seguir al padre.
@export var objetivo: Node2D

## Velocidad de suavizado del movimiento (Lerp).
@export var velocidad_suavizado: float = 5.0

@export_group("Look Ahead (Anticipación)")
## Si es true, la cámara se adelanta en la dirección del movimiento.
@export var usar_lookahead: bool = true
## Distancia máxima de anticipación en píxeles.
@export var distancia_lookahead: float = 100.0
## Velocidad de ajuste del lookahead.
@export var velocidad_lookahead: float = 2.0

@export_group("Screen Shake (Trauma)")
## Velocidad a la que el trauma (temblor) desaparece.
@export var decaimiento_trauma: float = 2.0
## Desplazamiento máximo en píxeles (intensidad del temblor).
@export var max_offset: Vector2 = Vector2(20, 20)
## Rotación máxima en radianes durante el temblor.
@export var max_roll: float = 0.1
## Ruido para generar el movimiento aleatorio (Opcional, usa randf si null).
@export var ruido: FastNoiseLite

# --- ESTADO ---
var trauma: float = 0.0 # 0.0 a 1.0
var _offset_lookahead: Vector2 = Vector2.ZERO
var _tiempo_ruido: float = 0.0

func _ready() -> void:
	if not objetivo:
		if get_parent() is Node2D:
			objetivo = get_parent()
			top_level = true # Desacoplarse para suavizado real independientemente del padre

	# Escuchar eventos globales automáticamente si el bus existe
	if Engine.has_singleton("EventBus"):
		var bus = Engine.get_singleton("EventBus")
		if bus.has_signal("entidad_danada"): # Asumiendo que la señal existe o se crea
			bus.connect("entidad_danada", _on_evento_global)
		# Alternativa genérica
		if bus.has_signal("evento_global"):
			bus.connect("evento_global", _on_evento_global_generico)

func _process(delta: float) -> void:
	if objetivo:
		var target_pos = objetivo.global_position
		
		# Lógica Lookahead
		if usar_lookahead:
			var velocity = Vector2.ZERO
			if objetivo is CharacterBody2D:
				velocity = objetivo.velocity
			elif "velocity" in objetivo:
				velocity = objetivo.velocity

			# Calcular offset deseado basado en velocidad
			var target_lookahead = Vector2.ZERO
			if velocity.length() > 10:
				target_lookahead = velocity.normalized() * distancia_lookahead

			_offset_lookahead = _offset_lookahead.lerp(target_lookahead, velocidad_lookahead * delta)
			target_pos += _offset_lookahead

		# Movimiento Suave
		global_position = global_position.lerp(target_pos, velocidad_suavizado * delta)

	# Lógica Shake
	if trauma > 0:
		trauma = max(trauma - decaimiento_trauma * delta, 0)
		_aplicar_shake(delta)
	elif offset != Vector2.ZERO or rotation != 0:
		# Resetear suavemente
		offset = offset.lerp(Vector2.ZERO, 10 * delta)
		rotation = lerp(rotation, 0.0, 10 * delta)

func _aplicar_shake(delta: float) -> void:
	var cantidad = trauma * trauma # Cuadrático
	_tiempo_ruido += delta * 30.0 # Velocidad del ruido

	if ruido:
		# Shake suave usando ruido Perlin/Simplex
		offset.x = max_offset.x * cantidad * ruido.get_noise_2d(_tiempo_ruido, 0)
		offset.y = max_offset.y * cantidad * ruido.get_noise_2d(0, _tiempo_ruido)
		rotation = max_roll * cantidad * ruido.get_noise_2d(_tiempo_ruido, _tiempo_ruido)
	else:
		# Shake aleatorio brusco
		offset.x = max_offset.x * cantidad * randf_range(-1, 1)
		offset.y = max_offset.y * cantidad * randf_range(-1, 1)
		rotation = max_roll * cantidad * randf_range(-1, 1)

## Añade trauma (0.0 a 1.0). Se acumula pero no pasa de 1.0.
func agregar_trauma(cantidad: float) -> void:
	trauma = min(trauma + cantidad, 1.0)

# --- EVENTOS ---

func _on_evento_global_generico(nombre: String, datos: Dictionary) -> void:
	if nombre == "shake":
		var fuerza = datos.get("fuerza", 0.5)
		agregar_trauma(fuerza)

func _on_evento_global(entidad, _cantidad, _critico) -> void:
	# Responder a daño
	if entidad.is_in_group("jugador"):
		agregar_trauma(0.5)
	elif entidad.is_in_group("enemigos"): # Ejemplo
		agregar_trauma(0.2)
