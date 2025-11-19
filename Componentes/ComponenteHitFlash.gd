# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHitFlash.gd
## Efecto visual de parpadeo al recibir daño.
##
## **Uso:** Añade este componente para que el sprite parpadee en blanco al ser golpeado.
## Mejora el feedback visual del combate.
##
## **Casos de uso:**
## - Jugador al recibir daño
## - Enemigos al ser golpeados
## - Objetos destructibles
##
## **Requisito:** El padre debe tener un Sprite2D o AnimatedSprite2D.
@icon("res://icon.svg")
class_name ComponenteHitFlash
extends Node
const _tool_context = "RuichisLab/Nodos"

@export var color_flash: Color = Color.WHITE
@export var duracion: float = 0.1

var sprite: CanvasItem
var hurtbox: Area2D
var shader_flash: ShaderMaterial

func _ready():
	# Buscar Sprite
	var padre = get_parent()
	for child in padre.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			sprite = child
			break
			
	if not sprite:
		# Si el padre es el sprite
		if padre is Sprite2D or padre is AnimatedSprite2D:
			sprite = padre
			
	# Buscar Hurtbox
	for child in padre.get_children():
		if child is ComponenteHurtbox:
			hurtbox = child
			break
			
	if hurtbox:
		hurtbox.dano_recibido.connect(_on_dano_recibido)
		
	# Crear material para el flash (usando modulación simple por ahora para compatibilidad)
	# Un shader sería mejor, pero modulate es "no-code" friendly y funciona en GLES2/3
	
func _on_dano_recibido(cantidad, origen):
	if sprite:
		flash()

func flash():
	# Método simple: Modulate
	# Nota: Esto tiñe el sprite. Para hacerlo totalmente blanco se necesita un Shader.
	# Vamos a intentar usar JuiceManager si existe, o un tween manual.
	
	if JuiceManager:
		JuiceManager.flash_sprite(sprite, color_flash, duracion)
	else:
		var tween = create_tween()
		var color_original = sprite.modulate
		sprite.modulate = color_flash
		tween.tween_property(sprite, "modulate", color_original, duracion)
