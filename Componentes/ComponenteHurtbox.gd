# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHurtbox.gd
## Área que recibe daño.
##
## **Uso:** Añade este componente a personajes/enemigos que pueden recibir daño.
## Detecta colisiones con Hitboxes y reduce la salud automáticamente.
##
## **Casos de uso:**
## - Jugador
## - Enemigos
## - Objetos destructibles
## - Jefes
##
## **Requisito:** Debe ser hijo de un Area2D. Requiere nodo Estadisticas.
class_name ComponenteHurtbox
extends Area2D
const _tool_context = "RuichisLab/Nodos"

# Este componente recibe daño y se lo pasa al nodo de Estadísticas.
# Debe ser hijo de una entidad que tenga 'Estadisticas'.

## Recurso de Estadísticas donde se aplicará el daño.
@export var nodo_estadisticas: Estadisticas
## Si es true, no recibe daño.
@export var invulnerable: bool = false

signal dano_recibido(cantidad: float, origen: Node)

func _ready():
	# Configuración típica para recibir daño
	collision_layer = 0 # No colisiona físicamente
	collision_mask = 0 # Se configura externamente o por defecto
	
	if not nodo_estadisticas:
		# Intentar buscarlo en el padre si no está asignado
		var padre = get_parent()
		if padre.has_node("Estadisticas"):
			nodo_estadisticas = padre.get_node("Estadisticas")

func recibir_dano(cantidad: float, origen: Node = null):
	if invulnerable: return
	
	print("%s recibió %f de daño" % [get_parent().name, cantidad])
	emit_signal("dano_recibido", cantidad, origen)
	
	# Notificar al sistema global (para textos flotantes, misiones, etc.)
	# Notificar al sistema global (para textos flotantes, misiones, etc.)
	var gm = _get_game_manager()
	if gm:
		gm.emitir_evento("dano_recibido", {"entidad": get_parent(), "cantidad": cantidad})
	
	if nodo_estadisticas:
		nodo_estadisticas.aplicar_dano(cantidad)
	else:
		push_warning("Hurtbox en %s no tiene nodo Estadisticas asignado." % get_parent().name)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not nodo_estadisticas:
		warnings.append("Asigna un nodo 'Estadisticas' para que el daño afecte la salud.")
	if not nodo_estadisticas:
		warnings.append("Asigna un nodo 'Estadisticas' para que el daño afecte la salud.")
	return warnings

func _get_game_manager() -> Node:
	if Engine.has_singleton("GameManager"): return Engine.get_singleton("GameManager")
	if is_inside_tree(): return get_tree().root.get_node_or_null("GameManager")
	return null