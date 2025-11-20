# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteHand.gd
## Gestor visual para la mano de cartas. Organiza los hijos en arco o línea.
##
## **Uso:** Contenedor para instancias de `RL_Card`.
## **Requisito:** Control (Container o Control simple).
@icon("res://addons/no_code_godot_plugin/deck_icon.png")
class_name RL_Hand
extends Control

# --- CONFIGURACIÓN ---

## Separación horizontal entre cartas.
@export var separacion: float = 80.0

## Curvatura del arco (grados máx de rotación).
@export var angulo_maximo: float = 15.0

## Desplazamiento vertical para el arco (píxeles).
@export var altura_arco: float = 30.0

## Velocidad de animación al reorganizar.
@export var velocidad_animacion: float = 0.2

# --- ESTADO ---
var _cartas: Array[Control] = []

func _ready() -> void:
	# Escuchar cambios en la jerarquía
	child_entered_tree.connect(_on_child_changed)
	child_exiting_tree.connect(_on_child_changed)

	# Reorganizar al cambiar tamaño
	resized.connect(organizar_cartas)

	call_deferred("organizar_cartas")

func _on_child_changed(_node: Node) -> void:
	call_deferred("organizar_cartas")

## Recalcula posiciones y rotaciones de todas las cartas.
func organizar_cartas() -> void:
	_cartas.clear()
	for child in get_children():
		if child is Control and child.visible: # Solo organizar Controles visibles
			_cartas.append(child)

	var total = _cartas.size()
	if total == 0: return
	
	var centro_x = size.x / 2.0

	# Calcular ancho total teórico
	var ancho_total = (total - 1) * separacion
	var inicio_x = centro_x - (ancho_total / 2.0)
	
	for i in range(total):
		var carta = _cartas[i]
		
		# Si la carta está siendo arrastrada, ignorarla visualmente
		if carta.has_method("is_dragged") and carta.is_dragged():
			continue
			
		# Posición X
		var target_x = inicio_x + (i * separacion) - (carta.size.x / 2.0)
		
		# Cálculo del arco
		var factor = 0.0 # -1.0 (izq) a 1.0 (der)
		if total > 1:
			factor = (float(i) / (total - 1)) * 2.0 - 1.0

		var target_y = abs(factor) * altura_arco
		var target_rot = factor * angulo_maximo
		
		# Animar
		var tween = create_tween().set_parallel(true)
		tween.tween_property(carta, "position", Vector2(target_x, target_y), velocidad_animacion).set_trans(Tween.TRANS_SINE)
		tween.tween_property(carta, "rotation_degrees", target_rot, velocidad_animacion).set_trans(Tween.TRANS_SINE)

		# Guardar referencia de "home" en la carta si es soportado
		if "_posicion_original" in carta:
			carta._posicion_original = Vector2(target_x, target_y)

func agregar_carta(carta: RL_Card) -> void:
	add_child(carta)
	# La señal child_entered_tree disparará la reorganización
