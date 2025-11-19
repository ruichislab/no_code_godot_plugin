# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDoor.gd
## Puerta que requiere llave para abrirse.
##
## **Uso:** Añade este componente a puertas bloqueadas.
## Verifica automáticamente si el jugador tiene la llave correcta.
##
## **Casos de uso:**
## - Puertas con llave
## - Portales bloqueados
## - Barreras mágicas
## - Checkpoints de seguridad
##
## **Requisito:** Debe ser hijo de un StaticBody2D.
@icon("res://icon.svg")
class_name ComponenteDoor
extends StaticBody2D
const _tool_context = "RuichisLab/Nodos"

@export var id_llave: String = "llave_roja"
@export var auto_abrir: bool = true # Abrir al tocar
@export var sonido_abrir: String = "door_open"
@export var sonido_bloqueado: String = "door_locked"

var abierta: bool = false

func _ready():
	# Detectar colisión para intentar abrir
	# Nota: StaticBody no detecta colisiones por sí mismo fácilmente sin un Area2D hijo.
	# Para simplificar, asumiremos que el usuario añade un Area2D hijo llamado "Detector"
	# O usaremos un Area2D interno si no existe.
	
	var detector = get_node_or_null("Detector")
	if not detector:
		detector = Area2D.new()
		detector.name = "Detector"
		add_child(detector)
		
		# Crear colisión para el detector (un poco más grande que la puerta)
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(40, 40) # Tamaño por defecto
		shape.shape = rect
		detector.add_child(shape)
		
	detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if abierta: return
	if not body.is_in_group("jugador") and body.name != "Jugador": return
	
	if auto_abrir:
		intentar_abrir()

func intentar_abrir():
	if VariableManager:
		if VariableManager.obtener_valor(id_llave):
			abrir()
		else:
			bloqueado()
	else:
		# Sin VariableManager, asumimos abierto para debug
		abrir()

func abrir():
	abierta = true
	print("Puerta abierta.")
	if SoundManager:
		SoundManager.play_sfx(sonido_abrir)
		
	# Desactivar colisión física
	collision_layer = 0
	collision_mask = 0
	
	# Ocultar o animar
	hide() # Simple: Desaparecer
	# TODO: Reproducir animación si existe AnimatedSprite2D

func bloqueado():
	print("Puerta cerrada. Necesitas: " + id_llave)
	if SoundManager:
		SoundManager.play_sfx(sonido_bloqueado)
	
	# Feedback visual (sacudida)
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x + 5, 0.05)
	tween.tween_property(self, "position:x", position.x - 5, 0.05)
	tween.tween_property(self, "position:x", position.x, 0.05)
