extends Resource
class_name RecursoEstadisticas

# --- ESTADÍSTICAS BASE ---
# Estas son las estadísticas "permanentes" o de base del personaje.

@export_group("Estadísticas Principales")
@export var salud_maxima: float = 100.0
@export var energia_maxima: float = 50.0   # O maná, o estamina...

@export_group("Estadísticas de Combate")
@export var fuerza: float = 10.0           # Afecta el daño físico
@export var magia: float = 10.0            # Afecta el daño mágico
@export var defensa: float = 5.0           # Reduce el daño recibido
@export var agilidad: float = 5.0          # Afecta la evasión o velocidad
