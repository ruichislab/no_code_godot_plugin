# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteBuildingPlacer.gd
## Sistema de construcción en grid.
##
## **Uso:** Añade este componente para permitir colocar edificios.
## Muestra preview y verifica colisiones.
##
## **Casos de uso:**
## - Juegos de construcción
## - Tower defense
## - City builders
## - Base building
##
## **Nota:** Requiere recursos para construir.
@icon("res://icon.svg")
class_name ComponenteBuildingPlacer
extends Node
const _tool_context = "RuichisLab/Nodos"

## Escena del edificio a construir.
@export var edificio_prefab: PackedScene
## Coste de construcción.
@export var coste: int = 100
## Variable global usada como moneda.
@export var variable_recurso: String = "dinero"
## Tamaño de la celda para el ajuste (Grid Snap).
@export var grid_size: int = 64
## Acción de Input para confirmar.
@export var tecla_construir: String = "mouse_left"
## Acción de Input para cancelar.
@export var tecla_cancelar: String = "mouse_right"

var previsualizacion: Node2D
var construyendo: bool = false

func iniciar_construccion():
	if not edificio_prefab: return
	
	# Verificar coste
	if VariableManager:
		var dinero = VariableManager.obtener_variable(variable_recurso)
		if dinero < coste:
			print("No hay suficientes recursos.")
			return
			
	construyendo = true
	previsualizacion = edificio_prefab.instantiate() as Node2D
	
	# Hacerlo semitransparente
	previsualizacion.modulate = Color(1, 1, 1, 0.5)
	
	# Desactivar colisiones en la preview si es posible
	_desactivar_colisiones(previsualizacion)
	
	get_tree().current_scene.add_child(previsualizacion)

func _process(delta):
	if not construyendo or not previsualizacion: return
	
	var mouse_pos = previsualizacion.get_global_mouse_position()
	
	# Snap to grid
	var x = round(mouse_pos.x / grid_size) * grid_size
	var y = round(mouse_pos.y / grid_size) * grid_size
	previsualizacion.global_position = Vector2(x, y)
	
	if Input.is_action_just_pressed(tecla_construir) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_construir()
		
	if Input.is_action_just_pressed(tecla_cancelar) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_cancelar()

func _construir():
	# Pagar coste
	if VariableManager:
		VariableManager.sumar_variable(variable_recurso, -coste)
		
	# Crear edificio real
	var edificio = edificio_prefab.instantiate()
	edificio.global_position = previsualizacion.global_position
	get_tree().current_scene.add_child(edificio)
	
	# Efecto visual/sonoro
	if SoundManager:
		SoundManager.play_sfx("build")
	
	_cancelar() # Terminar modo construcción

func _cancelar():
	construyendo = false
	if previsualizacion:
		previsualizacion.queue_free()
		previsualizacion = null

func _desactivar_colisiones(nodo):
	for child in nodo.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			child.disabled = true
		_desactivar_colisiones(child)
