# Archivo: Componentes/ComponenteHitbox.gd
## Área que causa daño.
##
## **Uso:** Añade este componente a ataques, proyectiles o trampas.
## Al tocar un Hurtbox, causa daño automáticamente.
##
## **Casos de uso:**
## - Espadas y armas cuerpo a cuerpo
## - Proyectiles (balas, flechas)
## - Trampas (pinchos, sierras)
## - Ataques de enemigos
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteHitbox
extends Area2D
const _tool_context = "RuichisLab/Nodos"

# Este componente inflige daño al tocar un Hurtbox.

## Cantidad de daño a infligir.
@export var dano: float = 10.0
## Fuerza de empuje (Knockback).
@export var empuje: float = 0.0 
## Si es true, el padre se destruye al causar daño (útil para balas).
@export var destruir_al_impactar: bool = false

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is ComponenteHurtbox:
		# Evitar dañarse a uno mismo (si el padre es el mismo)
		if area.get_parent() == get_parent(): return
		
		area.recibir_dano(dano, get_parent())
		
		if destruir_al_impactar:
			get_parent().queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if dano <= 0:
		warnings.append("El daño es 0 o negativo. Este Hitbox no hará nada.")
	return warnings
