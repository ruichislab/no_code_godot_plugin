# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHitFlash.gd
## Efecto visual de parpadeo blanco al recibir daño.
##
## **Uso:** Conectar a una Hurtbox o llamar `flash()`.
## **Mejora:** Usa un Shader Material si está disponible para hacer el sprite blanco puro, o modulación como fallback.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_HitFlash
extends Node

# --- CONFIGURACIÓN ---
@export var color_flash: Color = Color.WHITE
@export var duracion: float = 0.1

# --- ESTADO ---
var sprite: CanvasItem
var material_original: Material
var shader_flash: ShaderMaterial

func _ready() -> void:
	var padre = get_parent()

	# Buscar Sprite
	if padre is Sprite2D or padre is AnimatedSprite2D:
		sprite = padre
	else:
		for child in padre.get_children():
			if child is Sprite2D or child is AnimatedSprite2D:
				sprite = child
				break

	# Buscar Hurtbox hermana para auto-conexión
	for child in padre.get_children():
		if child is RL_Hurtbox or child.has_signal("dano_recibido"):
			if not child.dano_recibido.is_connected(_on_dano_recibido):
				child.dano_recibido.connect(_on_dano_recibido)

	_preparar_shader()

func _preparar_shader() -> void:
	# Crear un shader simple en código para no depender de archivos externos
	var codigo_shader = """
	shader_type canvas_item;
	uniform vec4 color_flash : source_color;
	uniform float intensidad : hint_range(0.0, 1.0);

	void fragment() {
		vec4 color_tex = texture(TEXTURE, UV);
		COLOR = mix(color_tex, color_flash, intensidad * color_tex.a);
	}
	"""
	var shader = Shader.new()
	shader.code = codigo_shader
	
	shader_flash = ShaderMaterial.new()
	shader_flash.shader = shader
	shader_flash.set_shader_parameter("color_flash", color_flash)
	shader_flash.set_shader_parameter("intensidad", 0.0)

func _on_dano_recibido(_cantidad: float, _origen: Node) -> void:
	flash()

## Inicia el efecto de parpadeo.
func flash() -> void:
	if not sprite: return
	
	# Método Shader (Preferido)
	if shader_flash:
		# Guardar material previo si no es el nuestro
		if sprite.material != shader_flash:
			material_original = sprite.material
			sprite.material = shader_flash

		var tween = create_tween()
		shader_flash.set_shader_parameter("intensidad", 1.0)
		tween.tween_method(func(val): shader_flash.set_shader_parameter("intensidad", val), 1.0, 0.0, duracion)
		tween.tween_callback(func():
			if material_original:
				sprite.material = material_original
			else:
				sprite.material = null
		)
	else:
		# Fallback Modulate (Tiñe, no blanquea perfecto)
		var tween = create_tween()
		var color_orig = sprite.modulate
		sprite.modulate = color_flash * 1.5 # Brillo extra
		tween.tween_property(sprite, "modulate", color_orig, duracion)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not get_parent() is Node2D:
		warnings.append("El padre debe ser un Node2D.")
	return warnings
