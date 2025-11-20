# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHitbox.gd
## Área que inflige daño al colisionar con una Hurtbox.
##
## **Uso:** Añadir a armas, proyectiles, trampas o enemigos.
## Detecta automáticamente áreas de tipo `RL_Hurtbox` y ejecuta su método `recibir_dano`.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Hitbox
extends Area2D

# --- CONFIGURACIÓN ---

## Cantidad de daño a infligir.
@export var dano: float = 10.0

## Fuerza de empuje (para sistemas de Knockback opcionales).
@export var fuerza_empuje: float = 0.0

## Vector de dirección del empuje. Si es (0,0), se calcula desde el centro.
@export var direccion_empuje: Vector2 = Vector2.ZERO

## Si es true, el objeto padre se destruye tras el primer impacto exitoso (ej: proyectiles simples).
@export var destruir_al_impactar: bool = false

## Grupo de equipos para evitar fuego amigo (ej: "jugador", "enemigo").
## Si se deja vacío, daña todo.
@export var equipo: String = ""

# --- SEÑALES ---
signal impacto_exitoso(objetivo: Area2D)

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Validar si es una Hurtbox válida (compatible con nuevo y viejo nombre por si acaso, o duck typing)
	var es_hurtbox = area is RL_Hurtbox or area.has_method("recibir_dano")

	if es_hurtbox:
		# Evitar dañarse a uno mismo o a su propio padre
		if area.get_parent() == get_parent(): return
		
		# Lógica de Equipos (Fuego Amigo)
		if equipo != "":
			var padre_area = area.get_parent()
			if padre_area.is_in_group(equipo):
				return # Es aliado, no dañar

		# Aplicar Daño
		if area.has_method("recibir_dano"):
			area.recibir_dano(dano, get_parent())

		emit_signal("impacto_exitoso", area)
		
		if destruir_al_impactar:
			# Pequeño delay opcional para permitir que se emitan señales o partículas antes de morir
			call_deferred("_destruir_padre")

func _destruir_padre() -> void:
	if get_parent():
		get_parent().queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if dano <= 0:
		warnings.append("El daño es 0 o negativo. Asegúrate de que es intencional.")

	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo.")

	return warnings
