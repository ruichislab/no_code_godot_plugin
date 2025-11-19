# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHealthBar.gd
## Barra de vida visual.
##
## **Uso:** Añade este componente para mostrar la vida de un personaje.
## Se actualiza automáticamente al recibir daño.
##
## **Casos de uso:**
## - Barra de vida del jugador
## - Barras de vida de enemigos
## - Barras de jefes
## - Indicadores de escudo
##
## **Requisito:** Debe heredar de ProgressBar. Requiere nodo Estadisticas.
@icon("res://icon.svg")
class_name ComponenteHealthBar
extends ProgressBar
const _tool_context = "RuichisLab/Nodos"

@export var nodo_estadisticas: Node
@export var ocultar_si_llena: bool = false
@export var suavizado: bool = true
@export var velocidad_suavizado: float = 5.0

var valor_objetivo: float = 0.0

func _ready():
	# Intentar encontrar estadísticas en el padre si no se asignó
	if not nodo_estadisticas:
		var padre = get_parent()
		if padre.has_node("Estadisticas"):
			nodo_estadisticas = padre.get_node("Estadisticas")
			
	if nodo_estadisticas:
		# Conectar señales (asumiendo que Estadisticas tiene señal 'salud_cambiada')
		if nodo_estadisticas.has_signal("salud_cambiada"):
			nodo_estadisticas.salud_cambiada.connect(_on_salud_cambiada)
			
		# Inicializar valores
		max_value = nodo_estadisticas.get("salud_maxima") if "salud_maxima" in nodo_estadisticas else 100
		valor_objetivo = nodo_estadisticas.get("salud_actual") if "salud_actual" in nodo_estadisticas else 100
		value = valor_objetivo
		
		_actualizar_visibilidad()

func _process(delta):
	if suavizado and value != valor_objetivo:
		value = move_toward(value, valor_objetivo, max_value * velocidad_suavizado * delta)

func _on_salud_cambiada(nuevo_valor, maximo):
	valor_objetivo = nuevo_valor
	max_value = maximo
	
	if not suavizado:
		value = valor_objetivo
		
	_actualizar_visibilidad()

func _actualizar_visibilidad():
	if ocultar_si_llena:
		visible = valor_objetivo < max_value
