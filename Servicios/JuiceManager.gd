# Archivo: addons/genesis_framework/Servicios/JuiceManager.gd
extends Node

# Configurar como Autoload: "JuiceManager"
# Biblioteca de efectos visuales para dar "Jugo" (Game Feel) a tus juegos.

# Efecto de parpadeo blanco (al recibir daño)
func flash_sprite(sprite: CanvasItem, color: Color = Color.WHITE, duracion: float = 0.1):
	if not sprite: return
	
	# Asegurarse de que el material sea único para no afectar a otros
	if not sprite.material:
		sprite.material = ShaderMaterial.new()
		# Aquí idealmente cargaríamos un shader de flash, pero usaremos modulate por simplicidad si no hay shader
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", color, 0.0)
		tween.tween_property(sprite, "modulate", Color.WHITE, duracion)
	else:
		# Si ya tiene shader, asumimos que tiene un param "flash_modifier"
		var tween = create_tween()
		sprite.material.set_shader_parameter("flash_modifier", 1.0)
		tween.tween_property(sprite.material, "shader_parameter/flash_modifier", 0.0, duracion)

# Efecto de "Squash & Stretch" (al saltar o aterrizar)
func squash_stretch(nodo: Node2D, escala_x: float, escala_y: float, duracion: float = 0.2):
	if not nodo: return
	
	var escala_original = Vector2.ONE # Asumimos 1,1 o guardamos la actual
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	nodo.scale = Vector2(escala_x, escala_y)
	tween.tween_property(nodo, "scale", escala_original, duracion)

# Efecto de flotación (para items)
func flotar(nodo: Node2D, altura: float = 5.0, velocidad: float = 2.0):
	if not nodo: return
	var tween = create_tween().set_loops()
	tween.tween_property(nodo, "position:y", nodo.position.y - altura, 1.0 / velocidad).set_trans(Tween.TRANS_SINE)
	tween.tween_property(nodo, "position:y", nodo.position.y, 1.0 / velocidad).set_trans(Tween.TRANS_SINE)
