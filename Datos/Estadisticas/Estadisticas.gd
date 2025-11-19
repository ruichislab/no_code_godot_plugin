# Archivo: Datos/Estadisticas/Estadisticas.gd
extends Node
class_name Estadisticas

# --- SEÑALES (PARA COMUNICACIÓN CON LA INTERFAZ) ---
# La interfaz se conectará a estas señales para actualizarse automáticamente.
signal salud_actualizada(valor_actual: float, valor_maximo: float)
signal mana_actualizado(valor_actual: float, valor_maximo: float)
signal nivel_subido(nuevo_nivel: int)
signal experiencia_actualizada(experiencia_actual: float, experiencia_necesaria: float)

# --- VARIABLES DE DATOS ESTÁTICOS (Base) ---
# Nota: Podrías cargar estas desde un Resource, pero por simplicidad las definimos aquí.

@export var nivel_actual: int = 1:
	set(value):
		nivel_actual = value
		emit_signal("nivel_subido", nivel_actual) # Emitir señal al subir de nivel

@export var experiencia_actual: float = 0.0

@export_group("Estadísticas Base")
@export var salud_maxima_base: float = 100.0
@export var mana_maximo_base: float = 50.0
@export var dano_base: float = 10.0
@export var defensa_base: float = 5.0

# --- VARIABLES DINÁMICAS (Actuales) ---

var salud_actual: float = salud_maxima_base:
	set(value):
		salud_actual = clamp(value, 0.0, obtener_salud_maxima_total())
		# Notificar a la UI sobre el cambio de salud
		emit_signal("salud_actualizada", salud_actual, obtener_salud_maxima_total())

var mana_actual: float = mana_maximo_base:
	set(value):
		mana_actual = clamp(value, 0.0, obtener_mana_maximo_total())
		# Notificar a la UI sobre el cambio de maná
		emit_signal("mana_actualizado", mana_actual, obtener_mana_maximo_total())

# --- MODIFICADORES DE EQUIPO/BUFFS ---
# Diccionario para sumar bonificaciones del equipo (armas, armaduras, etc.)
var modificadores_equipo: Dictionary = {
	"salud_extra": 0.0,
	"mana_extra": 0.0,
	"dano_extra": 0.0,
	"defensa_extra": 0.0,
	# Puedes añadir más como "velocidad_ataque", "critico", etc.
}


# --- CÁLCULOS TOTALES ---

func obtener_salud_maxima_total() -> float:
	return salud_maxima_base + modificadores_equipo.salud_extra

func obtener_mana_maximo_total() -> float:
	return mana_maximo_base + modificadores_equipo.mana_extra

func obtener_dano_total() -> float:
	return dano_base + modificadores_equipo.dano_extra

func obtener_defensa_total() -> float:
	return defensa_base + modificadores_equipo.defensa_extra

# --- FUNCIONES DE MODIFICACIÓN ---

func aplicar_dano(cantidad_dano: float):
	if cantidad_dano <= 0: return

	# Reducción por defensa (fórmula RPG simple)
	var dano_recibido = max(1.0, cantidad_dano - obtener_defensa_total())
	
	salud_actual -= dano_recibido
	
	print("Jugador recibió %f de daño." % dano_recibido)
	
	if salud_actual <= 0:
		_morir()

func sanar(cantidad_sanacion: float):
	if cantidad_sanacion <= 0: return
	
	salud_actual += cantidad_sanacion
	# El setter de 'salud_actual' se encarga de llamar a 'clamp' y emitir la señal

func usar_mana(cantidad_mana: float) -> bool:
	if mana_actual >= cantidad_mana:
		mana_actual -= cantidad_mana
		return true
	return false # Maná insuficiente

# --- LÓGICA DE EXPERIENCIA Y NIVEL ---

func obtener_experiencia_para_siguiente_nivel(nivel: int) -> float:
	# Fórmula simple de XP: (Nivel ^ 2) * 100
	return pow(float(nivel), 2.0) * 100.0

func anadir_experiencia(exp_ganada: float):
	experiencia_actual += exp_ganada
	
	while experiencia_actual >= obtener_experiencia_para_siguiente_nivel(nivel_actual):
		experiencia_actual -= obtener_experiencia_para_siguiente_nivel(nivel_actual)
		nivel_actual += 1 # Esto llama al setter y emite 'nivel_subido'
	
	# Notificar a la UI de la XP (incluso si no subió de nivel)
	emit_signal("experiencia_actualizada", 
		experiencia_actual, 
		obtener_experiencia_para_siguiente_nivel(nivel_actual)
	)

# --- ESTADO CRÍTICO ---

func _morir():
	print("El jugador ha muerto. Game Over.")
	# Aquí iría la lógica de reaparición o pantalla de Game Over

# --- SISTEMA DE GUARDADO ---

func guardar_datos() -> Dictionary:
	return {
		"nivel_actual": nivel_actual,
		"experiencia_actual": experiencia_actual,
		"salud_actual": salud_actual,
		"mana_actual": mana_actual,
		# "modificadores_equipo": modificadores_equipo # Si quieres guardar buffs persistentes
	}

func cargar_datos(datos: Dictionary):
	if datos.has("nivel_actual"): nivel_actual = datos.nivel_actual
	if datos.has("experiencia_actual"): experiencia_actual = datos.experiencia_actual
	
	# Usamos los setters para asegurar que se emitan las señales y se haga clamp
	if datos.has("salud_actual"): salud_actual = datos.salud_actual
	if datos.has("mana_actual"): mana_actual = datos.mana_actual
