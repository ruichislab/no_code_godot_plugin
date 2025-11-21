# Archivo: addons/no_code_godot_plugin/RuichisLabConfig.gd
## Script de configuración global del plugin.
## Se ejecuta al activar el plugin para configurar ProjectSettings.
@tool
extends RefCounted

static func configurar_proyecto() -> void:
	# Definir configuraciones por defecto
	_set_setting("ruichislab/general/debug_visual", true)
	_set_setting("ruichislab/colores/trigger", Color.GREEN)
	_set_setting("ruichislab/colores/dano", Color.RED)
	_set_setting("ruichislab/colores/portal", Color.BLUE)

	# Guardar si hubo cambios
	ProjectSettings.save()
	print("RuichisLab: Configuración del proyecto verificada.")

static func _set_setting(name: String, default_value: Variant) -> void:
	if not ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, default_value)
		ProjectSettings.set_initial_value(name, default_value)
		ProjectSettings.add_property_info({
			"name": name,
			"type": typeof(default_value)
		})
