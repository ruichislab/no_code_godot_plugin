# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDoor.gd
## Puerta que bloquea el paso hasta que se cumple una condición (variable global).
##
## **Uso:** Crea un StaticBody2D para bloquear físicamente.
## Este componente añade automáticamente un detector para abrirse si el jugador tiene la llave.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Door
extends StaticBody2D

# --- CONFIGURACIÓN ---

## Nombre de la variable booleana requerida (ej: "tiene_llave_roja").
@export var id_llave: String = "llave_roja"

## Si es true, intenta abrirse al contacto. Si false, requiere interacción externa.
@export var auto_abrir: bool = true

## Sonido al abrirse.
@export var sonido_abrir: String = "door_open"

## Sonido al intentar abrir sin llave.
@export var sonido_bloqueado: String = "door_locked"

## Si es true, la puerta desaparece (`queue_free`) al abrirse. Si false, solo desactiva colisión y se oculta.
@export var destruir_al_abrir: bool = false

var abierta: bool = false

func _ready() -> void:
	# Autogenerar detector si no existe un hijo Area2D
	var detector = null
	for child in get_children():
		if child is Area2D:
			detector = child
			break
	
	if not detector:
		detector = Area2D.new()
		detector.name = "DetectorAutomatico"
		add_child(detector)
		
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(64, 64) # Un poco más grande para detectar antes de chocar
		shape.shape = rect
		detector.add_child(shape)

	if not detector.body_entered.is_connected(_on_body_entered):
		detector.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if abierta: return
	if body.is_in_group("jugador") or body.name == "Jugador":
		if auto_abrir:
			intentar_abrir()

## Intenta abrir la puerta verificando la variable.
func intentar_abrir() -> void:
	var tiene_llave = false

	# Verificar Variable
	if Engine.has_singleton("VariableManager"):
		var vm = Engine.get_singleton("VariableManager")
		if vm.has_method("obtener_valor"):
			tiene_llave = vm.obtener_valor(id_llave)
	else:
		# Modo debug: Si no hay manager, abrir siempre o nunca según preferencia
		# print("Debug: VariableManager no encontrado, puerta asume llave=true")
		tiene_llave = true

	if tiene_llave:
		abrir()
	else:
		bloqueado()

func abrir() -> void:
	if abierta: return
	abierta = true

	# print("Puerta abierta.")
	if sonido_abrir != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_abrir)
		
	# Desactivar colisión física
	collision_layer = 0
	collision_mask = 0
	
	# Animación / Destrucción
	if destruir_al_abrir:
		queue_free()
	else:
		hide()
		# TODO: Soporte para AnimatedSprite2D ("open")

func bloqueado() -> void:
	# print("Puerta cerrada. Necesitas: " + id_llave)
	if sonido_bloqueado != "" and Engine.has_singleton("AudioManager"):
		Engine.get_singleton("AudioManager").call("play_sfx", sonido_bloqueado)
	
	# Feedback visual (Shake simple)
	var tween = create_tween()
	var x_orig = position.x
	tween.tween_property(self, "position:x", x_orig + 5, 0.05)
	tween.tween_property(self, "position:x", x_orig - 5, 0.05)
	tween.tween_property(self, "position:x", x_orig, 0.05)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	# Validar colisión propia (del StaticBody)
	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("El StaticBody2D necesita un CollisionShape2D para bloquear físicamente.")
	return warnings
