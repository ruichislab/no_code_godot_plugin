# Archivo: addons/no_code_godot_plugin/Componentes/ComponenteEfectos.gd
## Gestión de efectos de estado (buffs/debuffs).
##
## **Uso:** Añade este componente para aplicar efectos temporales.
## Soporta veneno, quemadura, congelación, etc.
##
## **Casos de uso:**
## - Veneno que daña con el tiempo
## - Quemaduras
## - Congelación que ralentiza
## - Buffs de velocidad
## - Escudos temporales
##
## **Nota:** Los efectos se definen como Resources.
@icon("res://icon.svg")
class_name ComponenteEfectos
extends Node
const _tool_context = "RuichisLab/Nodos"

# Gestiona una lista de efectos activos (Veneno, Regeneración, etc.)

signal efecto_aplicado(efecto: RecursoEfecto)
signal efecto_removido(efecto: RecursoEfecto)

# Estructura: { "id_efecto": { "recurso": RecursoEfecto, "tiempo_restante": 5.0, "stacks": 1 } }
var efectos_activos: Dictionary = {}

func _process(delta):
	# Actualizar temporizadores
	var ids_a_borrar = []
	
	for id in efectos_activos:
		var datos = efectos_activos[id]
		var efecto = datos.recurso
		
		# Lógica de actualización (Tick)
		efecto.al_actualizar(get_parent(), delta)
		
		# Lógica de duración
		if efecto.duracion > 0:
			datos.tiempo_restante -= delta
			if datos.tiempo_restante <= 0:
				ids_a_borrar.append(id)
				
	for id in ids_a_borrar:
		remover_efecto(id)

func aplicar_efecto(nuevo_efecto: RecursoEfecto):
	if not nuevo_efecto: return
	
	var id = nuevo_efecto.id_efecto
	
	if efectos_activos.has(id):
		# Ya existe, refrescar o acumular
		var datos = efectos_activos[id]
		datos.tiempo_restante = nuevo_efecto.duracion # Refrescar duración
		
		if nuevo_efecto.es_acumulable and datos.stacks < nuevo_efecto.max_acumulaciones:
			datos.stacks += 1
			print("Efecto %s acumulado: %d" % [nuevo_efecto.nombre, datos.stacks])
	else:
		# Nuevo efecto
		efectos_activos[id] = {
			"recurso": nuevo_efecto,
			"tiempo_restante": nuevo_efecto.duracion,
			"stacks": 1
		}
		nuevo_efecto.al_aplicar(get_parent())
		emit_signal("efecto_aplicado", nuevo_efecto)
		print("Efecto aplicado: " + nuevo_efecto.nombre)

func remover_efecto(id_efecto: String):
	if efectos_activos.has(id_efecto):
		var datos = efectos_activos[id_efecto]
		datos.recurso.al_remover(get_parent())
		efectos_activos.erase(id_efecto)
		emit_signal("efecto_removido", datos.recurso)
		print("Efecto removido: " + datos.recurso.nombre)
