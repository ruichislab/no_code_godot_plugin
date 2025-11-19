# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteSaveSlotButton.gd
## Botón de slot de guardado.
##
## **Uso:** Añade este componente para crear sistemas de múltiples partidas.
## Muestra información del guardado y permite cargar/borrar.
##
## **Casos de uso:**
## - Selector de partida
## - Sistema de guardado múltiple
## - Perfiles de jugador
##
## **Requisito:** Debe heredar de Button. Requiere SistemaGuardado.
@icon("res://icon.svg")
class_name ComponenteSaveSlotButton
extends Button
const _tool_context = "RuichisLab/Nodos"

enum Modo { GUARDAR, CARGAR }
@export var modo: Modo = Modo.CARGAR
@export var slot: int = 1
@export var formato_vacio: String = "Ranura %d - Vacía"
@export var formato_lleno: String = "Ranura %d - %s" # %s es la fecha
@export var escena_juego: String = "res://Niveles/Nivel1.tscn" # Para cargar si no hay escena guardada (opcional)

func _ready():
	actualizar_info()
	pressed.connect(_on_pressed)

func actualizar_info():
	var meta = SistemaGuardado.obtener_metadata(slot)
	if meta.is_empty():
		text = formato_vacio % slot
	else:
		text = formato_lleno % [slot, meta.get("fecha", "???")]

func _on_pressed():
	if modo == Modo.GUARDAR:
		SistemaGuardado.guardar_juego(slot)
		actualizar_info()
		print("Guardado en Slot %d" % slot)
		
	elif modo == Modo.CARGAR:
		if SistemaGuardado.existe_partida(slot):
			if SistemaGuardado.cargar_juego(slot):
				print("Cargado Slot %d" % slot)
				# Opcional: Cambiar a escena de juego si estamos en menú principal
				# Esto requiere saber en qué escena se guardó, lo cual añadimos a metadata o datos
				# Por ahora, recargar escena actual o ir a una por defecto
				# get_tree().reload_current_scene() 
		else:
			print("Slot %d vacío." % slot)
