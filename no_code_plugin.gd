@tool
extends EditorPlugin

func _enter_tree():
	# 1. Limpieza preventiva
	_remove_old_types()
	
	# 2. REGISTRO DE AUTOLOADS
	_registrar_autoloads()
	
	# 3. REGISTRO DE NODOS (Todos bajo RuichisLab/ directamente)
	
	# LÓGICA
	add_custom_type("RuichisLab/Logic/Trigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrigger.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/InputListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputListener.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/GameOverListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGameOverListener.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/PauseListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePauseListener.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/Interaccion", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInteraccion.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/SimpleDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSimpleDialog.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/AdvancedDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAdvancedDialog.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/QuestGiver", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestGiver.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/QuestObjective", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestObjective.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/Key", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKey.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/Door", "StaticBody2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDoor.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/ItemChest", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteItemChest.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/SavePoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSavePoint.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/Shop", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShop.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Logic/Timer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTimer.gd"), preload("res://icon.svg"))

	# COMBATE
	add_custom_type("RuichisLab/Combat/Hurtbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHurtbox.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Hitbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitbox.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/LootDropper", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLootDropper.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Destructible", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDestructible.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/MeleeWeapon", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMeleeWeapon.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Dash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDash.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Knockback", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKnockback.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Efectos", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteEfectos.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/HitFlash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitFlash.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Trail", "Line2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrail.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/OnDeath", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOnDeath.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Combat/Proyectil", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteProyectil.gd"), preload("res://icon.svg"))

	# IA
	add_custom_type("RuichisLab/AI/MaquinaEstados", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMaquinaEstados.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/AI/BehaviorTree", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBehaviorTree.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/AI/Patrol", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/AI/Follower", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFollower.gd"), preload("res://icon.svg"))

	# UTILIDADES
	add_custom_type("RuichisLab/Utils/CamaraJuicy", "Camera2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/Spawner", "Marker2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/HealthBar", "ProgressBar", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHealthBar.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/DataLabel", "Label", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDataLabel.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/Floating", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFloating.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/Rotator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteRotator.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/LookAt", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLookAt.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/Footsteps", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFootsteps.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/Collectible", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/SceneButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSceneButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/OpenMenuButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOpenMenuButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/MenuManager", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMenuManager.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/QuitButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuitButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/VolumeSlider", "HSlider", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVolumeSlider.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/SaveSlotButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSaveSlotButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/InputRemapButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputRemapButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Utils/InventoryGrid", "GridContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInventoryGrid.gd"), preload("res://icon.svg"))

	# ESTRATEGIA
	add_custom_type("RuichisLab/Strategy/TurnManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTurnManager.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Strategy/Selectable", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSelectable.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Strategy/GridMovement", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGridMovement.gd"), preload("res://icon.svg"))

	# CARTAS
	add_custom_type("RuichisLab/Cards/Card", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCard.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Cards/Hand", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHand.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Cards/Deck", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDeck.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Cards/DiscardPile", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDiscardPile.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Cards/CardSlot", "PanelContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCardSlot.gd"), preload("res://icon.svg"))

	# TYCOON
	add_custom_type("RuichisLab/Tycoon/ResourceGenerator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteResourceGenerator.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Tycoon/BuildingPlacer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBuildingPlacer.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Tycoon/Clicker", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteClicker.gd"), preload("res://icon.svg"))

	# RPG
	add_custom_type("RuichisLab/RPG/UpgradeButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteUpgradeButton.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/RPG/Crafter", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCrafter.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/RPG/Experience", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteExperience.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/RPG/TopDownController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTopDownController.gd"), preload("res://icon.svg"))

	# MUNDO
	add_custom_type("RuichisLab/World/DayNightCycle", "CanvasModulate", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDayNightCycle.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/Weather", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteWeather.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/SoundArea", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSoundArea.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/DamageZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/Bouncer", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBouncer.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/ParallaxScroll", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteParallaxScroll.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/ShakeTrigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShakeTrigger.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/LevelPortal", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLevelPortal.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/CameraZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCameraZone.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/LightFlicker", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLightFlicker.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/Teleporter", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/AreaEffect", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAreaEffect.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/World/MovingPlatform", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMovingPlatform.gd"), preload("res://icon.svg"))

	# PLATAFORMAS
	add_custom_type("RuichisLab/Platformer/PlatformerController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd"), preload("res://icon.svg"))

	# CARRERAS
	add_custom_type("RuichisLab/Racing/CarController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCarController.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Racing/LapManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLapManager.gd"), preload("res://icon.svg"))
	add_custom_type("RuichisLab/Racing/Checkpoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCheckpoint.gd"), preload("res://icon.svg"))

	# MÓVIL
	add_custom_type("RuichisLab/Mobile/VirtualJoystick", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd"), preload("res://icon.svg"))

	# PUZZLE
	add_custom_type("RuichisLab/Puzzle/Pushable", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePushable.gd"), preload("res://icon.svg"))

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
	print("No-code-Godot-Plugin: Autoloads registrados")

func _remover_autoloads():
	remove_autoload_singleton("GameManager")
	remove_autoload_singleton("AudioManager")
	remove_autoload_singleton("SaveManager")
	remove_autoload_singleton("PoolManager")
	print("No-code-Godot-Plugin: Autoloads removidos")

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
	for type in current_types:
		remove_custom_type(type)

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
	for type in old_types:
		remove_custom_type(type)
