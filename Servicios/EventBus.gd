# Archivo: Servicios/EventBus.gd
extends Node

# Configurar como Autoload: "EventBus"
# Este script actúa como una centralita de eventos global.
# Cualquier script puede emitir o escuchar señales aquí sin conocerse entre sí.

# --- COMBATE ---
signal entidad_danada(entidad: Node, cantidad: float, es_critico: bool)
signal entidad_murio(entidad: Node)

# --- MUNDO ---
signal item_recogido(item: RecursoObjeto, cantidad: int)
signal zona_cambiada(nombre_zona: String)

# --- SISTEMA ---
signal idioma_cambiado
signal configuracion_actualizada

# Función helper para emitir con seguridad
func emitir_dano(entidad: Node, cantidad: float, es_critico: bool = false):
	emit_signal("entidad_danada", entidad, cantidad, es_critico)
