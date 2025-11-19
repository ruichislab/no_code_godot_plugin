# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd
## Zona que causa daño continuo.
##
## **Uso:** Añade este componente para crear zonas peligrosas.
## Causa daño mientras el jugador permanece dentro.
##
## **Casos de uso:**
## - Lava
## - Ácido
## - Zonas tóxicas
## - Campos eléctricos
## - Fuego
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteDamageZone
extends Area2D
const _tool_context = "RuichisLab/Nodos"

@export var dano_por_segundo: float = 10.0
@export var intervalo: float = 0.5 # Cada cuánto aplica el daño

var objetivos: Array[ComponenteHurtbox] = []
var timer: float = 0.0

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	if objetivos.is_empty(): return
	
	timer -= delta
	if timer <= 0:
		timer = intervalo
		_aplicar_dano()

func _aplicar_dano():
	var dano_tick = dano_por_segundo * intervalo
	for hurtbox in objetivos:
		if is_instance_valid(hurtbox):
			hurtbox.recibir_dano(dano_tick, self)

func _on_area_entered(area):
	if area is ComponenteHurtbox:
		objetivos.append(area)

func _on_area_exited(area):
	if area in objetivos:
		objetivos.erase(area)
