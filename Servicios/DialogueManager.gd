# Archivo: addons/genesis_framework/Servicios/DialogueManager.gd
extends Node

# Configurar como Autoload: "DialogueManager"

signal dialogo_iniciado(recurso: RecursoDialogo)
signal linea_mostrada(texto: String, nombre: String)
signal opciones_mostradas(opciones: Dictionary)
signal dialogo_terminado()

var dialogo_actual: RecursoDialogo
var indice_linea: int = 0

func iniciar_dialogo(recurso: RecursoDialogo):
	if not recurso: return
	
	dialogo_actual = recurso
	indice_linea = 0
	
	emit_signal("dialogo_iniciado", recurso)
	mostrar_siguiente_linea()

func mostrar_siguiente_linea():
	if not dialogo_actual: return
	
	if indice_linea < dialogo_actual.lineas.size():
		var linea = dialogo_actual.lineas[indice_linea]
		emit_signal("linea_mostrada", linea, dialogo_actual.nombre_personaje)
		
		# Reproducir sonido si existe
		if dialogo_actual.sonido_voz and SoundManager:
			SoundManager.play_sfx_stream(dialogo_actual.sonido_voz)
			
		indice_linea += 1
	else:
		# Fin de líneas, mostrar opciones o terminar
		if dialogo_actual.opciones.size() > 0:
			emit_signal("opciones_mostradas", dialogo_actual.opciones)
		else:
			terminar_dialogo()

func seleccionar_opcion(id_siguiente_dialogo: String):
	# Aquí cargaríamos el siguiente recurso de diálogo si tuviéramos una base de datos
	# Por simplicidad, en esta versión v1.0, solo cerramos o imprimimos
	print("Opción seleccionada -> Ir a: " + id_siguiente_dialogo)
	terminar_dialogo()

func terminar_dialogo():
	if dialogo_actual:
		# Ejecutar acciones
		for accion in dialogo_actual.acciones_al_terminar:
			if accion.has_method("ejecutar"):
				accion.ejecutar()
				
	dialogo_actual = null
	emit_signal("dialogo_terminado")
