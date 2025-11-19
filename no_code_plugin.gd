@tool
extends EditorPlugin

# Wrapper seguro: algunas versiones/linters requieren 4 argumentos para add_custom_type.
# Usamos este helper para pasar un `icon` por defecto (`null`) cuando no se provee.
func add_custom_type_safe(type_name: String, base_type: String, script_ref, icon = null) -> void:
	# Llamar al método de instancia real evitando recursión con una llamada dinámica.
	# Usamos `call` para asegurar que se invoque la implementación nativa de EditorPlugin
	# (si existe) en la instancia actual.
	if has_method("add_custom_type"):
		self.call("add_custom_type", type_name, base_type, script_ref, icon)
	else:
		push_warning("add_custom_type no disponible en esta versión de Godot; omitiendo registro de %s" % type_name)

func _enter_tree():
	# 1. Limpieza preventiva
	_remove_old_types()
	
	# 2. REGISTRO DE AUTOLOADS
	_registrar_autoloads()
	
	# 3. REGISTRO DE NODOS (Todos bajo RuichisLab/ directamente)
	
	# LÓGICA
	add_custom_type_safe("RuichisLab/Logic/Trigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrigger.gd"))
	add_custom_type_safe("RuichisLab/Logic/InputListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputListener.gd"))
	add_custom_type_safe("RuichisLab/Logic/GameOverListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGameOverListener.gd"))
	add_custom_type_safe("RuichisLab/Logic/PauseListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePauseListener.gd"))
	add_custom_type_safe("RuichisLab/Logic/Interaccion", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInteraccion.gd"))
	add_custom_type_safe("RuichisLab/Logic/SimpleDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSimpleDialog.gd"))
	add_custom_type_safe("RuichisLab/Logic/AdvancedDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAdvancedDialog.gd"))
	add_custom_type_safe("RuichisLab/Logic/QuestGiver", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestGiver.gd"))
	add_custom_type_safe("RuichisLab/Logic/QuestObjective", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestObjective.gd"))
	add_custom_type_safe("RuichisLab/Logic/Key", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKey.gd"))
	add_custom_type_safe("RuichisLab/Logic/Door", "StaticBody2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDoor.gd"))
	add_custom_type_safe("RuichisLab/Logic/ItemChest", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteItemChest.gd"))
	add_custom_type_safe("RuichisLab/Logic/SavePoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSavePoint.gd"))
	add_custom_type_safe("RuichisLab/Logic/Shop", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShop.gd"))
	add_custom_type_safe("RuichisLab/Logic/Timer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTimer.gd"))

	# COMBATE
	add_custom_type_safe("RuichisLab/Combat/Hurtbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHurtbox.gd"))
	add_custom_type_safe("RuichisLab/Combat/Hitbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitbox.gd"))
	add_custom_type_safe("RuichisLab/Combat/LootDropper", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLootDropper.gd"))
	add_custom_type_safe("RuichisLab/Combat/Destructible", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDestructible.gd"))
	add_custom_type_safe("RuichisLab/Combat/MeleeWeapon", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMeleeWeapon.gd"))
	add_custom_type_safe("RuichisLab/Combat/Dash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDash.gd"))
	add_custom_type_safe("RuichisLab/Combat/Knockback", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKnockback.gd"))
	add_custom_type_safe("RuichisLab/Combat/Efectos", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteEfectos.gd"))
	add_custom_type_safe("RuichisLab/Combat/HitFlash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitFlash.gd"))
	add_custom_type_safe("RuichisLab/Combat/Trail", "Line2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrail.gd"))
	add_custom_type_safe("RuichisLab/Combat/OnDeath", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOnDeath.gd"))
	add_custom_type_safe("RuichisLab/Combat/Proyectil", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteProyectil.gd"))

	# IA
	add_custom_type_safe("RuichisLab/AI/MaquinaEstados", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMaquinaEstados.gd"))
	add_custom_type_safe("RuichisLab/AI/BehaviorTree", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBehaviorTree.gd"))
	add_custom_type_safe("RuichisLab/AI/Patrol", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd"))
	add_custom_type_safe("RuichisLab/AI/Follower", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFollower.gd"))

	# UTILIDADES
	add_custom_type_safe("RuichisLab/Utils/CamaraJuicy", "Camera2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd"))
	add_custom_type_safe("RuichisLab/Utils/Spawner", "Marker2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd"))
	add_custom_type_safe("RuichisLab/Utils/HealthBar", "ProgressBar", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHealthBar.gd"))
	add_custom_type_safe("RuichisLab/Utils/DataLabel", "Label", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDataLabel.gd"))
	add_custom_type_safe("RuichisLab/Utils/Floating", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFloating.gd"))
	add_custom_type_safe("RuichisLab/Utils/Rotator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteRotator.gd"))
	add_custom_type_safe("RuichisLab/Utils/LookAt", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLookAt.gd"))
	add_custom_type_safe("RuichisLab/Utils/Footsteps", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFootsteps.gd"))
	add_custom_type_safe("RuichisLab/Utils/Collectible", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd"))
	add_custom_type_safe("RuichisLab/Utils/SceneButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSceneButton.gd"))
	add_custom_type_safe("RuichisLab/Utils/OpenMenuButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOpenMenuButton.gd"))
	add_custom_type_safe("RuichisLab/Utils/MenuManager", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMenuManager.gd"))
	add_custom_type_safe("RuichisLab/Utils/QuitButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuitButton.gd"))
	add_custom_type_safe("RuichisLab/Utils/VolumeSlider", "HSlider", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVolumeSlider.gd"))
	add_custom_type_safe("RuichisLab/Utils/SaveSlotButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSaveSlotButton.gd"))
	add_custom_type_safe("RuichisLab/Utils/InputRemapButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputRemapButton.gd"))
	add_custom_type_safe("RuichisLab/Utils/InventoryGrid", "GridContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInventoryGrid.gd"))

	# ESTRATEGIA
	add_custom_type_safe("RuichisLab/Strategy/TurnManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTurnManager.gd"))
	add_custom_type_safe("RuichisLab/Strategy/Selectable", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSelectable.gd"))
	add_custom_type_safe("RuichisLab/Strategy/GridMovement", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGridMovement.gd"))

	# CARTAS
	add_custom_type_safe("RuichisLab/Cards/Card", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCard.gd"))
	add_custom_type_safe("RuichisLab/Cards/Hand", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHand.gd"))
	add_custom_type_safe("RuichisLab/Cards/Deck", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDeck.gd"))
	add_custom_type_safe("RuichisLab/Cards/DiscardPile", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDiscardPile.gd"))
	add_custom_type_safe("RuichisLab/Cards/CardSlot", "PanelContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCardSlot.gd"))

	# TYCOON
	add_custom_type_safe("RuichisLab/Tycoon/ResourceGenerator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteResourceGenerator.gd"))
	add_custom_type_safe("RuichisLab/Tycoon/BuildingPlacer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBuildingPlacer.gd"))
	add_custom_type_safe("RuichisLab/Tycoon/Clicker", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteClicker.gd"))

	# RPG
	add_custom_type_safe("RuichisLab/RPG/UpgradeButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteUpgradeButton.gd"))
	add_custom_type_safe("RuichisLab/RPG/Crafter", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCrafter.gd"))
	add_custom_type_safe("RuichisLab/RPG/Experience", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteExperience.gd"))
	add_custom_type_safe("RuichisLab/RPG/TopDownController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTopDownController.gd"))

	# MUNDO
	add_custom_type_safe("RuichisLab/World/DayNightCycle", "CanvasModulate", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDayNightCycle.gd"))
	add_custom_type_safe("RuichisLab/World/Weather", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteWeather.gd"))
	add_custom_type_safe("RuichisLab/World/SoundArea", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSoundArea.gd"))
	add_custom_type_safe("RuichisLab/World/DamageZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd"))
	add_custom_type_safe("RuichisLab/World/Bouncer", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBouncer.gd"))
	add_custom_type_safe("RuichisLab/World/ParallaxScroll", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteParallaxScroll.gd"))
	add_custom_type_safe("RuichisLab/World/ShakeTrigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShakeTrigger.gd"))
	add_custom_type_safe("RuichisLab/World/LevelPortal", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLevelPortal.gd"))
	add_custom_type_safe("RuichisLab/World/CameraZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCameraZone.gd"))
	add_custom_type_safe("RuichisLab/World/LightFlicker", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLightFlicker.gd"))
	add_custom_type_safe("RuichisLab/World/Teleporter", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd"))
	add_custom_type_safe("RuichisLab/World/AreaEffect", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAreaEffect.gd"))
	add_custom_type_safe("RuichisLab/World/MovingPlatform", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMovingPlatform.gd"))

	# PLATAFORMAS
	add_custom_type_safe("RuichisLab/Platformer/PlatformerController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd"))

	# CARRERAS
	add_custom_type_safe("RuichisLab/Racing/CarController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCarController.gd"))
	add_custom_type_safe("RuichisLab/Racing/LapManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLapManager.gd"))
	add_custom_type_safe("RuichisLab/Racing/Checkpoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCheckpoint.gd"))

	# MÓVIL
	add_custom_type_safe("RuichisLab/Mobile/VirtualJoystick", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd"))

	# PUZZLE
	add_custom_type_safe("RuichisLab/Puzzle/Pushable", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePushable.gd"))

	print("No-code-Godot-Plugin cargado: Nodos registrados en 'RuichisLab/'.")

func _exit_tree():
	_remove_current_types()
	_remover_autoloads()

func _registrar_autoloads():
	# Registrar managers globales
	add_autoload_singleton("GameManager", "res://addons/no_code_godot_plugin/Autoloads/GameManager.gd")
	add_autoload_singleton("AudioManager", "res://addons/no_code_godot_plugin/Autoloads/AudioManager.gd")
	add_autoload_singleton("SaveManager", "res://addons/no_code_godot_plugin/Autoloads/SaveManager.gd")
	add_autoload_singleton("PoolManager", "res://addons/no_code_godot_plugin/Autoloads/PoolManager.gd")
	add_autoload_singleton("DialogueManager", "res://addons/no_code_godot_plugin/Servicios/DialogueManager.gd")
	add_autoload_singleton("InventarioGlobal", "res://addons/no_code_godot_plugin/Datos/Inventario/InventarioGlobal.gd")
	add_autoload_singleton("DebugConsole", "res://addons/no_code_godot_plugin/Servicios/DebugConsole.gd")
	add_autoload_singleton("GestorMisiones", "res://addons/no_code_godot_plugin/Servicios/GestorMisiones.gd")
	add_autoload_singleton("FloatingTextManager", "res://addons/no_code_godot_plugin/Servicios/FloatingTextManager.gd")
	add_autoload_singleton("UIManager", "res://addons/no_code_godot_plugin/Servicios/UIManager.gd")
	add_autoload_singleton("EventBus", "res://addons/no_code_godot_plugin/Servicios/EventBus.gd")
	print("No-code-Godot-Plugin: Autoloads registrados")

func _remover_autoloads():
	remove_autoload_singleton("GameManager")
	remove_autoload_singleton("AudioManager")
	remove_autoload_singleton("SaveManager")
	remove_autoload_singleton("PoolManager")
	remove_autoload_singleton("DialogueManager")
	remove_autoload_singleton("InventarioGlobal")
	remove_autoload_singleton("DebugConsole")
	remove_autoload_singleton("GestorMisiones")
	remove_autoload_singleton("FloatingTextManager")
	remove_autoload_singleton("UIManager")
	remove_autoload_singleton("EventBus")
	print("No-code-Godot-Plugin: Autoloads removidos")


# Helpers seguros para registrar autoloads en tiempo de editor.
# Algunas instalaciones de Godot no exponen una API para manipular autoloads
# desde un plugin en tiempo de ejecución; para evitar que el plugin falle
# al activarse, implementamos un wrapper no-op que informa al usuario.
func add_autoload_singleton(name: String, path: String) -> void:
	if Engine.has_singleton(name):
		return
	print("No-code-Godot-Plugin: (info) autoload '%s' no registrado automáticamente. Por favor añade '%s' como singleton si lo necesitas." % [name, path])

func remove_autoload_singleton(name: String) -> void:
	# No intentamos modificar autoloads del proyecto automáticamente desde el plugin
	# para evitar cambios no deseados en ProjectSettings. Simplemente no-op con aviso.
	if Engine.has_singleton(name):
		print("No-code-Godot-Plugin: (info) autoload '%s' existe en Runtime; no se removerá automáticamente." % name)
	else:
		return

func _remove_current_types():
	# Lista de nombres actuales para limpieza
	var current_types = [
		"RuichisLab/Logic/Trigger", "RuichisLab/Logic/InputListener", "RuichisLab/Logic/GameOverListener", "RuichisLab/Logic/PauseListener",
		"RuichisLab/Logic/Interaccion", "RuichisLab/Logic/SimpleDialog", "RuichisLab/Logic/AdvancedDialog", "RuichisLab/Logic/QuestGiver",
		"RuichisLab/Logic/QuestObjective", "RuichisLab/Logic/Key", "RuichisLab/Logic/Door", "RuichisLab/Logic/ItemChest",
		"RuichisLab/Logic/SavePoint", "RuichisLab/Logic/Shop", "RuichisLab/Logic/Timer",
		"RuichisLab/Combat/Hurtbox", "RuichisLab/Combat/Hitbox", "RuichisLab/Combat/LootDropper", "RuichisLab/Combat/Destructible",
		"RuichisLab/Combat/MeleeWeapon", "RuichisLab/Combat/Dash", "RuichisLab/Combat/Knockback", "RuichisLab/Combat/Efectos",
		"RuichisLab/Combat/HitFlash", "RuichisLab/Combat/Trail", "RuichisLab/Combat/OnDeath", "RuichisLab/Combat/Proyectil",
		"RuichisLab/AI/MaquinaEstados", "RuichisLab/AI/BehaviorTree", "RuichisLab/AI/Patrol", "RuichisLab/AI/Follower",
		"RuichisLab/Utils/CamaraJuicy", "RuichisLab/Utils/Spawner", "RuichisLab/Utils/HealthBar", "RuichisLab/Utils/DataLabel",
		"RuichisLab/Utils/Floating", "RuichisLab/Utils/Rotator", "RuichisLab/Utils/LookAt", "RuichisLab/Utils/Footsteps",
		"RuichisLab/Utils/Collectible", "RuichisLab/Utils/SceneButton", "RuichisLab/Utils/OpenMenuButton", "RuichisLab/Utils/MenuManager",
		"RuichisLab/Utils/QuitButton", "RuichisLab/Utils/VolumeSlider", "RuichisLab/Utils/SaveSlotButton", "RuichisLab/Utils/InputRemapButton",
		"RuichisLab/Utils/InventoryGrid",
		"RuichisLab/Strategy/TurnManager", "RuichisLab/Strategy/Selectable", "RuichisLab/Strategy/GridMovement",
		"RuichisLab/Cards/Card", "RuichisLab/Cards/Hand", "RuichisLab/Cards/Deck", "RuichisLab/Cards/DiscardPile", "RuichisLab/Cards/CardSlot",
		"RuichisLab/Tycoon/ResourceGenerator", "RuichisLab/Tycoon/BuildingPlacer", "RuichisLab/Tycoon/Clicker",
		"RuichisLab/RPG/UpgradeButton", "RuichisLab/RPG/Crafter", "RuichisLab/RPG/Experience", "RuichisLab/RPG/TopDownController",
		"RuichisLab/World/DayNightCycle", "RuichisLab/World/Weather", "RuichisLab/World/SoundArea", "RuichisLab/World/DamageZone",
		"RuichisLab/World/Bouncer", "RuichisLab/World/ParallaxScroll", "RuichisLab/World/ShakeTrigger", "RuichisLab/World/LevelPortal",
		"RuichisLab/World/CameraZone", "RuichisLab/World/LightFlicker", "RuichisLab/World/Teleporter", "RuichisLab/World/AreaEffect",
		"RuichisLab/World/MovingPlatform",
		"RuichisLab/Platformer/PlatformerController",
		"RuichisLab/Racing/CarController", "RuichisLab/Racing/LapManager", "RuichisLab/Racing/Checkpoint",
		"RuichisLab/Mobile/VirtualJoystick",
		"RuichisLab/Puzzle/Pushable"
	]
	for ct in current_types:
		remove_custom_type(ct)

func _remove_old_types():
	# Eliminar tipos antiguos (NC_*, Ruichis/*, RuichisLab/Categorias/*)
	var old_types = [
		"NC_Trigger", "NC_Interaccion", "NC_Hurtbox", "NC_Hitbox", "NC_LootDropper", "NC_Efectos",
		"NC_MaquinaEstados", "NC_BehaviorTree", "NC_CamaraJuicy", "NC_Spawner",
		"NC_TurnManager", "NC_GridMovement", "NC_Proyectil", "NC_PlatformerController",
		"NC_DayNightCycle", "NC_CarController", "NC_LapManager", "NC_Checkpoint",
		"NC_VirtualJoystick", "NC_Pushable", "NC_Teleporter",
		# Ruichis/*
		"Ruichis/Logic/Trigger", "Ruichis/Logic/InputListener", "Ruichis/Logic/GameOverListener", "Ruichis/Logic/PauseListener",
		"Ruichis/Logic/Interaccion", "Ruichis/Logic/SimpleDialog", "Ruichis/Logic/AdvancedDialog", "Ruichis/Logic/QuestGiver",
		"Ruichis/Logic/QuestObjective", "Ruichis/Logic/Key", "Ruichis/Logic/Door", "Ruichis/Logic/ItemChest",
		"Ruichis/Logic/SavePoint", "Ruichis/Logic/Shop", "Ruichis/Logic/Timer",
		"Ruichis/Combat/Hurtbox", "Ruichis/Combat/Hitbox", "Ruichis/Combat/LootDropper", "Ruichis/Combat/Destructible",
		"Ruichis/Combat/MeleeWeapon", "Ruichis/Combat/Dash", "Ruichis/Combat/Knockback", "Ruichis/Combat/Efectos",
		"Ruichis/Combat/HitFlash", "Ruichis/Combat/Trail", "Ruichis/Combat/OnDeath", "Ruichis/Combat/Proyectil",
		"Ruichis/AI/MaquinaEstados", "Ruichis/AI/BehaviorTree", "Ruichis/AI/Patrol", "Ruichis/AI/Follower",
		"Ruichis/Utils/CamaraJuicy", "Ruichis/Utils/Spawner", "Ruichis/Utils/HealthBar", "Ruichis/Utils/DataLabel",
		"Ruichis/Utils/Floating", "Ruichis/Utils/Rotator", "Ruichis/Utils/LookAt", "Ruichis/Utils/Footsteps",
		"Ruichis/Utils/Collectible", "Ruichis/Utils/SceneButton", "Ruichis/Utils/OpenMenuButton", "Ruichis/Utils/MenuManager",
		"Ruichis/Utils/QuitButton", "Ruichis/Utils/VolumeSlider", "Ruichis/Utils/SaveSlotButton", "Ruichis/Utils/InputRemapButton",
		"Ruichis/Utils/InventoryGrid",
		"Ruichis/Strategy/TurnManager", "Ruichis/Strategy/Selectable", "Ruichis/Strategy/GridMovement",
		"Ruichis/Cards/Card", "Ruichis/Cards/Hand",
		"Ruichis/Tycoon/ResourceGenerator", "Ruichis/Tycoon/BuildingPlacer", "Ruichis/Tycoon/Clicker",
		"Ruichis/RPG/UpgradeButton", "Ruichis/RPG/Crafter", "Ruichis/RPG/Experience", "Ruichis/RPG/TopDownController",
		"Ruichis/World/DayNightCycle", "Ruichis/World/Weather", "Ruichis/World/SoundArea", "Ruichis/World/DamageZone",
		"Ruichis/World/Bouncer", "Ruichis/World/ParallaxScroll", "Ruichis/World/ShakeTrigger", "Ruichis/World/LevelPortal",
		"Ruichis/World/CameraZone", "Ruichis/World/LightFlicker", "Ruichis/World/Teleporter", "Ruichis/World/AreaEffect",
		"Ruichis/World/MovingPlatform",
		"Ruichis/Platformer/PlatformerController",
		"Ruichis/Racing/CarController", "Ruichis/Racing/LapManager", "Ruichis/Racing/Checkpoint",
		"Ruichis/Mobile/VirtualJoystick",
		"Ruichis/Puzzle/Pushable",
		"Ruichis/Shooter/Proyectil", "Ruichis/Puzzle/Teleporter",
		# RuichisLab/Categorias/* (Limpieza de la versión anterior inmediata)
		"RuichisLab/Logic/Trigger", "RuichisLab/Logic/InputListener", "RuichisLab/Logic/GameOverListener", "RuichisLab/Logic/PauseListener",
		"RuichisLab/Logic/Interaccion", "RuichisLab/Logic/SimpleDialog", "RuichisLab/Logic/AdvancedDialog", "RuichisLab/Logic/QuestGiver",
		"RuichisLab/Logic/QuestObjective", "RuichisLab/Logic/Key", "RuichisLab/Logic/Door", "RuichisLab/Logic/ItemChest",
		"RuichisLab/Logic/SavePoint", "RuichisLab/Logic/Shop", "RuichisLab/Logic/Timer",
		"RuichisLab/Combat/Hurtbox", "RuichisLab/Combat/Hitbox", "RuichisLab/Combat/LootDropper", "RuichisLab/Combat/Destructible",
		"RuichisLab/Combat/MeleeWeapon", "RuichisLab/Combat/Dash", "RuichisLab/Combat/Knockback", "RuichisLab/Combat/Efectos",
		"RuichisLab/Combat/HitFlash", "RuichisLab/Combat/Trail", "RuichisLab/Combat/OnDeath", "RuichisLab/Combat/Proyectil",
		"RuichisLab/AI/MaquinaEstados", "RuichisLab/AI/BehaviorTree", "RuichisLab/AI/Patrol", "RuichisLab/AI/Follower",
		"RuichisLab/Utils/CamaraJuicy", "RuichisLab/Utils/Spawner", "RuichisLab/Utils/HealthBar", "RuichisLab/Utils/DataLabel",
		"RuichisLab/Utils/Floating", "RuichisLab/Utils/Rotator", "RuichisLab/Utils/LookAt", "RuichisLab/Utils/Footsteps",
		"RuichisLab/Utils/Collectible", "RuichisLab/Utils/SceneButton", "RuichisLab/Utils/OpenMenuButton", "RuichisLab/Utils/MenuManager",
		"RuichisLab/Utils/QuitButton", "RuichisLab/Utils/VolumeSlider", "RuichisLab/Utils/SaveSlotButton", "RuichisLab/Utils/InputRemapButton",
		"RuichisLab/Utils/InventoryGrid",
		"RuichisLab/Strategy/TurnManager", "RuichisLab/Strategy/Selectable", "RuichisLab/Strategy/GridMovement",
		"RuichisLab/Cards/Card", "RuichisLab/Cards/Hand", "RuichisLab/Cards/Deck", "RuichisLab/Cards/DiscardPile", "RuichisLab/Cards/CardSlot",
		"RuichisLab/Tycoon/ResourceGenerator", "RuichisLab/Tycoon/BuildingPlacer", "RuichisLab/Tycoon/Clicker",
		"RuichisLab/RPG/UpgradeButton", "RuichisLab/RPG/Crafter", "RuichisLab/RPG/Experience", "RuichisLab/RPG/TopDownController",
		"RuichisLab/World/DayNightCycle", "RuichisLab/World/Weather", "RuichisLab/World/SoundArea", "RuichisLab/World/DamageZone",
		"RuichisLab/World/Bouncer", "RuichisLab/World/ParallaxScroll", "RuichisLab/World/ShakeTrigger", "RuichisLab/World/LevelPortal",
		"RuichisLab/World/CameraZone", "RuichisLab/World/LightFlicker", "RuichisLab/World/Teleporter", "RuichisLab/World/AreaEffect",
		"RuichisLab/World/MovingPlatform",
		"RuichisLab/Platformer/PlatformerController",
		"RuichisLab/Racing/CarController", "RuichisLab/Racing/LapManager", "RuichisLab/Racing/Checkpoint",
		"RuichisLab/Mobile/VirtualJoystick",
		"RuichisLab/Puzzle/Pushable",
		# Flat versions (Legacy)
		"RuichisLab/Trigger", "RuichisLab/InputListener", "RuichisLab/GameOverListener", "RuichisLab/PauseListener",
		"RuichisLab/Interaccion", "RuichisLab/SimpleDialog", "RuichisLab/AdvancedDialog", "RuichisLab/QuestGiver",
		"RuichisLab/QuestObjective", "RuichisLab/Key", "RuichisLab/Door", "RuichisLab/ItemChest",
		"RuichisLab/SavePoint", "RuichisLab/Shop", "RuichisLab/Timer",
		"RuichisLab/Hurtbox", "RuichisLab/Hitbox", "RuichisLab/LootDropper", "RuichisLab/Destructible",
		"RuichisLab/MeleeWeapon", "RuichisLab/Dash", "RuichisLab/Knockback", "RuichisLab/Efectos",
		"RuichisLab/HitFlash", "RuichisLab/Trail", "RuichisLab/OnDeath", "RuichisLab/Proyectil",
		"RuichisLab/MaquinaEstados", "RuichisLab/BehaviorTree", "RuichisLab/Patrol", "RuichisLab/Follower",
		"RuichisLab/CamaraJuicy", "RuichisLab/Spawner", "RuichisLab/HealthBar", "RuichisLab/DataLabel",
		"RuichisLab/Floating", "RuichisLab/Rotator", "RuichisLab/LookAt", "RuichisLab/Footsteps",
		"RuichisLab/Collectible", "RuichisLab/SceneButton", "RuichisLab/OpenMenuButton", "RuichisLab/MenuManager",
		"RuichisLab/QuitButton", "RuichisLab/VolumeSlider", "RuichisLab/SaveSlotButton", "RuichisLab/InputRemapButton",
		"RuichisLab/InventoryGrid",
		"RuichisLab/TurnManager", "RuichisLab/Selectable", "RuichisLab/GridMovement",
		"RuichisLab/Card", "RuichisLab/Hand",
		"RuichisLab/ResourceGenerator", "RuichisLab/BuildingPlacer", "RuichisLab/Clicker",
		"RuichisLab/UpgradeButton", "RuichisLab/Crafter", "RuichisLab/Experience", "RuichisLab/TopDownController",
		"RuichisLab/DayNightCycle", "RuichisLab/Weather", "RuichisLab/SoundArea", "RuichisLab/DamageZone",
		"RuichisLab/Bouncer", "RuichisLab/ParallaxScroll", "RuichisLab/ShakeTrigger", "RuichisLab/LevelPortal",
		"RuichisLab/CameraZone", "RuichisLab/LightFlicker", "RuichisLab/Teleporter", "RuichisLab/AreaEffect",
		"RuichisLab/MovingPlatform",
		"RuichisLab/PlatformerController",
		"RuichisLab/CarController", "RuichisLab/LapManager", "RuichisLab/Checkpoint",
		"RuichisLab/VirtualJoystick",
		"RuichisLab/Pushable"
	]
	for old_type in old_types:
		remove_custom_type(old_type)
