# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteDayNightCycle.gd
## Ciclo de día/noche automático.
##
## **Uso:** Añade este componente para crear ciclos de día/noche.
## Cambia gradualmente el color de la iluminación.
##
## **Casos de uso:**
## - Juegos de supervivencia
## - RPGs con tiempo real
## - Simuladores de granja
## - Juegos de mundo abierto
##
## **Requisito:** Debe heredar de CanvasModulate.
@icon("res://icon.svg")
class_name ComponenteDayNightCycle
extends CanvasModulate
const _tool_context = "RuichisLab/Nodos"

## Duración de un día completo de juego en minutos reales.
@export var duracion_dia_minutos: float = 10.0
## Color de la luz ambiente durante el día.
@export var color_dia: Color = Color.WHITE
## Color de la luz ambiente durante la noche.
@export var color_noche: Color = Color(0.1, 0.1, 0.35, 1.0)
## Color de la luz ambiente durante el atardecer/amanecer.
@export var color_atardecer: Color = Color(1.0, 0.5, 0.3, 1.0)

var tiempo_actual: float = 0.0 # 0.0 a 1.0 (0 = inicio día, 0.5 = mediodía, 1.0 = fin)

func _process(delta):
	# Avanzar tiempo
	var avance = delta / (duracion_dia_minutos * 60.0)
	tiempo_actual += avance
	if tiempo_actual >= 1.0:
		tiempo_actual = 0.0
		
	# Calcular color
	# 0.0 - 0.2: Amanecer (Noche -> Día)
	# 0.2 - 0.7: Día
	# 0.7 - 0.8: Atardecer (Día -> Atardecer -> Noche)
	# 0.8 - 1.0: Noche
	
	if tiempo_actual < 0.2:
		color = color_noche.lerp(color_dia, tiempo_actual / 0.2)
	elif tiempo_actual < 0.7:
		color = color_dia
	elif tiempo_actual < 0.8:
		var t = (tiempo_actual - 0.7) / 0.1
		color = color_dia.lerp(color_atardecer, t)
	else:
		var t = (tiempo_actual - 0.8) / 0.2
		color = color_atardecer.lerp(color_noche, t)
