# Archivo: addons/no_code_godot_plugin/Editor/AsistenteCreacion.gd
@tool
extends EditorScript

## Script de herramienta para generar una estructura de escena básica.
## Ejecutar desde: Archivo > Ejecutar Tool Script (Ctrl+Shift+X) o mediante plugin.

func _run() -> void:
	var raiz = get_scene()
	if not raiz:
		print("Error: Abre una escena vacía o selecciona un nodo raíz.")
		return

	var undo = get_editor_interface().get_undo_redo()
	undo.create_action("Crear Estructura RuichisLab")

	# 1. Crear Nivel
	var nivel = Node2D.new()
	nivel.name = "Nivel"
	undo.add_do_method(raiz, "add_child", nivel)
	undo.add_do_reference(nivel)
	undo.add_undo_method(raiz, "remove_child", nivel)

	# 2. Crear Jugador
	var jugador = CharacterBody2D.new()
	jugador.name = "Jugador"
	jugador.add_to_group("jugador")
	undo.add_do_method(nivel, "add_child", jugador)
	undo.add_do_reference(jugador)

	# Añadir componentes al jugador
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	# sprite.texture = load("res://icon.svg") # Fallback
	undo.add_do_method(jugador, "add_child", sprite)
	undo.add_do_reference(sprite)

	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var rect = RectangleShape2D.new()
	rect.size = Vector2(64, 64)
	col.shape = rect
	undo.add_do_method(jugador, "add_child", col)
	undo.add_do_reference(col)

	# Añadir controlador (cargando script dinámicamente)
	var script_controller = load("res://addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd")
	if script_controller:
		var controller = Node.new()
		controller.name = "RL_PlatformerController"
		controller.set_script(script_controller)
		undo.add_do_method(jugador, "add_child", controller)
		undo.add_do_reference(controller)

	# 3. Crear UI
	var ui = CanvasLayer.new()
	ui.name = "UI"
	undo.add_do_method(raiz, "add_child", ui)
	undo.add_do_reference(ui)

	undo.commit_action()
	print("RuichisLab: Estructura de escena creada con éxito.")
