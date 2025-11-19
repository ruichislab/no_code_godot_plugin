# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteTrigger.gd
## Ejecuta acciones cuando algo entra en su área.
##
## **Uso:** Añade este componente a un Area2D para crear zonas interactivas.
## Detecta automáticamente al jugador y ejecuta una lista de acciones personalizables.
##
## **Casos de uso:**
## - Puertas que se abren al acercarse
## - Trampas que se activan al pisar
## - Puntos de guardado automático
## - Inicio de diálogos o cinemáticas
## - Cambios de nivel o teletransporte
##
## **Requisito:** Debe ser hijo de un Area2D.
@icon("res://icon.svg")
class_name ComponenteTrigger
extends Area2D
const _tool_context = "RuichisLab/Nodos"

# --- CONFIGURACIÓN ---

## Lista de acciones a ejecutar (Sonido, Mensaje, Variable, etc).
@export var acciones: Array[Resource] = []

## Si es true, solo se ejecutará una vez y luego se desactivará.
@export var una_sola_vez: bool = false

## Probabilidad de ejecución (0.0 a 1.0). 1.0 es siempre.
@export_range(0.0, 1.0) var probabilidad: float = 1.0

## Delay en segundos antes de ejecutar las acciones.
@export var delay: float = 0.0

# --- ESTADO INTERNO ---
var _ya_ejecutado: bool = false

func _ready():
	# Conectar señal de entrada de cuerpo
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	# Filtrar: Por defecto reacciona al jugador.
	# Se podría expandir para filtrar por grupos específicos.
	if body.is_in_group("jugador") or body.name == "Jugador":
		activar(body)

## Ejecuta manualmente el trigger.
func activar(actor: Node = null):
	if _ya_ejecutado and una_sola_vez: return
	
	if probabilidad < 1.0 and randf() > probabilidad:
		return

	if una_sola_vez:
		_ya_ejecutado = true
		
	if delay > 0:
		await get_tree().create_timer(delay).timeout
		
	print("Trigger activado por: ", actor.name if actor else "Nadie")
	
	for accion in acciones:
		# Duck typing: Verificar si el recurso tiene el método 'ejecutar'
		if accion and accion.has_method("ejecutar"):
			accion.ejecutar(actor)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if acciones.is_empty():
		warnings.append("El Trigger no tiene ninguna acción asignada. No hará nada al activarse.")
	return warnings
