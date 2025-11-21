# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd
## Zona que aplica daño periódico a las Hurtboxes que entran.
##
## **Uso:** Lava, veneno, pinchos estáticos.
## **Requisito:** Hijo de Area2D. Detecta `RL_Hurtbox`.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_DamageZone
extends Area2D

# --- CONFIGURACIÓN ---

## Daño total por segundo.
@export var dano_por_segundo: float = 10.0

## Intervalo de aplicación del daño (segundos).
@export var intervalo: float = 0.5

# Estado interno
var objetivos: Array[Area2D] = [] # Lista de Hurtboxes válidas
var timer: float = 0.0

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not area_exited.is_connected(_on_area_exited):
		area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	if objetivos.is_empty(): return
	
	timer -= delta
	if timer <= 0:
		timer = intervalo
		_aplicar_dano()

func _aplicar_dano() -> void:
	var dano_tick = dano_por_segundo * intervalo

	# Iterar sobre copia para evitar problemas si se borran durante iteración
	var objetivos_activos = objetivos.duplicate()

	for hurtbox in objetivos_activos:
		if is_instance_valid(hurtbox) and hurtbox.has_method("recibir_dano"):
			hurtbox.recibir_dano(dano_tick, self)
		else:
			# Limpieza perezosa
			objetivos.erase(hurtbox)

func _on_area_entered(area: Area2D) -> void:
	# Duck typing o verificación de clase
	var es_hurtbox = area is RL_Hurtbox or area.has_method("recibir_dano")

	if es_hurtbox and not area in objetivos:
		objetivos.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area in objetivos:
		objetivos.erase(area)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	var tiene_colision = false
	for child in get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			tiene_colision = true
			break
	if not tiene_colision:
		warnings.append("Se requiere un CollisionShape2D hijo.")
	return warnings
