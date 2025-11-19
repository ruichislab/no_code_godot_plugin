# Archivo: addons/genesis_framework/Servicios/AchievementManager.gd
extends Node

# Configurar como Autoload: "AchievementManager"

signal logro_desbloqueado(id: String, titulo: String)
signal progreso_logro(id: String, actual: int, objetivo: int)

# Estructura: { "id_logro": { "titulo": "Cazador", "objetivo": 10, "actual": 0, "desbloqueado": false } }
var logros: Dictionary = {}

func registrar_logro(id: String, titulo: String, objetivo: int = 1):
	if logros.has(id): return
	logros[id] = {
		"titulo": titulo,
		"objetivo": objetivo,
		"actual": 0,
		"desbloqueado": false
	}

func avanzar_logro(id: String, cantidad: int = 1):
	if not logros.has(id): return
	var datos = logros[id]
	
	if datos.desbloqueado: return
	
	datos.actual += cantidad
	emit_signal("progreso_logro", id, datos.actual, datos.objetivo)
	
	if datos.actual >= datos.objetivo:
		desbloquear_logro(id)

func desbloquear_logro(id: String):
	if not logros.has(id): return
	var datos = logros[id]
	
	if datos.desbloqueado: return
	
	datos.desbloqueado = true
	datos.actual = datos.objetivo
	emit_signal("logro_desbloqueado", id, datos.titulo)
	print("LOGRO DESBLOQUEADO: " + datos.titulo)

func guardar_progreso():
	var archivo = FileAccess.open("user://achievements.dat", FileAccess.WRITE)
	if archivo:
		archivo.store_string(JSON.stringify(logros))

func cargar_progreso():
	if not FileAccess.file_exists("user://achievements.dat"): return
	
	var archivo = FileAccess.open("user://achievements.dat", FileAccess.READ)
	var json = JSON.new()
	if json.parse(archivo.get_as_text()) == OK:
		var datos_cargados = json.data
		for id in datos_cargados:
			if logros.has(id):
				logros[id].actual = datos_cargados[id].actual
				logros[id].desbloqueado = datos_cargados[id].desbloqueado
