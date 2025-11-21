# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDayNightCycle.gd
## Ciclo Día/Noche basado en Gradientes.
##
## **Uso:** Modula el color del CanvasLayer para simular el paso del tiempo.
## **Requisito:** CanvasModulate.
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_DayNightCycle
extends CanvasModulate

# --- SEÑALES ---
signal hora_cambiada(hora: int) # 0-23
signal dia_nuevo(dia: int)

# --- CONFIGURACIÓN ---

## Duración de un día completo en minutos reales.
@export var duracion_dia_minutos: float = 10.0

## Gradiente que define el color de la luz a lo largo del día.
## Izquierda (0.0) = Medianoche, Centro (0.5) = Mediodía, Derecha (1.0) = Medianoche.
@export var gradiente_dia: Gradient

## Hora inicial (0.0 a 24.0).
@export_range(0.0, 24.0) var hora_inicial: float = 12.0

# --- ESTADO ---
var tiempo_actual: float = 0.0 # 0.0 a 1.0 (normalizado)
var dia_actual: int = 1
var _ultima_hora_entera: int = -1

func _ready() -> void:
	# Inicializar tiempo normalizado desde hora inicial
	tiempo_actual = hora_inicial / 24.0

	if not gradiente_dia:
		_crear_gradiente_por_defecto()

func _process(delta: float) -> void:
	if duracion_dia_minutos <= 0: return

	# Avance del tiempo
	var avance = delta / (duracion_dia_minutos * 60.0)
	tiempo_actual += avance

	if tiempo_actual >= 1.0:
		tiempo_actual = 0.0
		dia_actual += 1
		emit_signal("dia_nuevo", dia_actual)
		
	# Aplicar color
	if gradiente_dia:
		color = gradiente_dia.sample(tiempo_actual)

	# Señal de hora
	var hora_entera = int(tiempo_actual * 24.0)
	if hora_entera != _ultima_hora_entera:
		_ultima_hora_entera = hora_entera
		emit_signal("hora_cambiada", hora_entera)

func _crear_gradiente_por_defecto() -> void:
	gradiente_dia = Gradient.new()
	# 0.0 (00:00) - Noche Profunda
	gradiente_dia.add_point(0.0, Color(0.05, 0.05, 0.2))
	# 0.2 (05:00) - Amanecer
	gradiente_dia.add_point(0.2, Color(0.3, 0.2, 0.3))
	# 0.3 (07:00) - Mañana
	gradiente_dia.add_point(0.3, Color(0.9, 0.85, 0.7))
	# 0.5 (12:00) - Mediodía (Blanco puro)
	gradiente_dia.add_point(0.5, Color.WHITE)
	# 0.7 (17:00) - Tarde
	gradiente_dia.add_point(0.7, Color(0.9, 0.7, 0.6))
	# 0.8 (19:00) - Atardecer
	gradiente_dia.add_point(0.8, Color(0.4, 0.2, 0.3))
	# 1.0 (24:00) - Noche
	gradiente_dia.add_point(1.0, Color(0.05, 0.05, 0.2))

func obtener_hora_string() -> String:
	var h = int(tiempo_actual * 24.0)
	var m = int((tiempo_actual * 24.0 - h) * 60.0)
	return "%02d:%02d" % [h, m]
