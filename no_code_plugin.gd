@tool
extends EditorPlugin

# Wrapper seguro: algunas versiones/linters requieren 4 argumentos para add_custom_type.
func add_custom_type_safe(type_name: String, base_type: String, script_ref, icon = null) -> void:
	if has_method("add_custom_type"):
		self.call("add_custom_type", type_name, base_type, script_ref, icon)
	else:
		push_warning("add_custom_type no disponible en esta versión de Godot; omitiendo registro de %s" % type_name)

func _enter_tree() -> void:
	# 1. Limpieza preventiva de versiones antiguas
	_remove_old_types()
	
	# 2. REGISTRO DE AUTOLOADS
	_registrar_autoloads()
	
	# 3. REGISTRO DE NODOS
	
	var icon_default = EditorInterface.get_base_control().get_theme_icon("Node", "EditorIcons")
	var icon_area = EditorInterface.get_base_control().get_theme_icon("Area2D", "EditorIcons")
	# var icon_anim = EditorInterface.get_base_control().get_theme_icon("AnimationPlayer", "EditorIcons")

	# LOGICA
	add_custom_type_safe("RuichisLab/Logic/Trigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrigger.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/InputListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputListener.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Logic/GameOverListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGameOverListener.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Logic/PauseListener", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePauseListener.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Logic/Interaccion", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInteraccion.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/SimpleDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSimpleDialog.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/AdvancedDialog", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAdvancedDialog.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/QuestGiver", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestGiver.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/QuestObjective", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuestObjective.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/Key", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKey.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/Door", "StaticBody2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDoor.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Logic/ItemChest", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteItemChest.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/SavePoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSavePoint.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/Shop", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShop.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Logic/Timer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTimer.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Logic/SimpleAnimator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSimpleAnimator.gd"), icon_default)

	# COMBATE
	add_custom_type_safe("RuichisLab/Combat/Hurtbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHurtbox.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Combat/Hitbox", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitbox.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Combat/LootDropper", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLootDropper.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Destructible", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDestructible.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/MeleeWeapon", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMeleeWeapon.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Dash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDash.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Knockback", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteKnockback.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Efectos", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteEfectos.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/HitFlash", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHitFlash.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Trail", "Line2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTrail.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/OnDeath", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOnDeath.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Combat/Proyectil", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteProyectil.gd"), icon_default)

	# IA
	add_custom_type_safe("RuichisLab/AI/MaquinaEstados", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMaquinaEstados.gd"), icon_default)
	add_custom_type_safe("RuichisLab/AI/BehaviorTree", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBehaviorTree.gd"), icon_default)
	add_custom_type_safe("RuichisLab/AI/Patrol", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePatrol.gd"), icon_default)
	add_custom_type_safe("RuichisLab/AI/Follower", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFollower.gd"), icon_default)

	# UTILIDADES
	add_custom_type_safe("RuichisLab/Utils/CamaraJuicy", "Camera2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCamara.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/Spawner", "Marker2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSpawner.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/HealthBar", "ProgressBar", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHealthBar.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/DataLabel", "Label", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDataLabel.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/Floating", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFloating.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/Rotator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteRotator.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/LookAt", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLookAt.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/Footsteps", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteFootsteps.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/Collectible", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCollectible.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Utils/SceneButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSceneButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/OpenMenuButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteOpenMenuButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/MenuManager", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMenuManager.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/QuitButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteQuitButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/VolumeSlider", "HSlider", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVolumeSlider.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/SaveSlotButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSaveSlotButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/InputRemapButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInputRemapButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Utils/InventoryGrid", "GridContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteInventoryGrid.gd"), icon_default)

	# ESTRATEGIA
	add_custom_type_safe("RuichisLab/Strategy/TurnManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTurnManager.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Strategy/Selectable", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSelectable.gd"), icon_area)
	add_custom_type_safe("RuichisLab/Strategy/GridMovement", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteGridMovement.gd"), icon_default)

	# CARTAS
	add_custom_type_safe("RuichisLab/Cards/Card", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCard.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Cards/Hand", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteHand.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Cards/Deck", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDeck.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Cards/DiscardPile", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDiscardPile.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Cards/CardSlot", "PanelContainer", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCardSlot.gd"), icon_default)

	# TYCOON
	add_custom_type_safe("RuichisLab/Tycoon/ResourceGenerator", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteResourceGenerator.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Tycoon/BuildingPlacer", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBuildingPlacer.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Tycoon/Clicker", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteClicker.gd"), icon_area)

	# RPG
	add_custom_type_safe("RuichisLab/RPG/UpgradeButton", "Button", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteUpgradeButton.gd"), icon_default)
	add_custom_type_safe("RuichisLab/RPG/Crafter", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCrafter.gd"), icon_default)
	add_custom_type_safe("RuichisLab/RPG/Experience", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteExperience.gd"), icon_default)
	add_custom_type_safe("RuichisLab/RPG/TopDownController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTopDownController.gd"), icon_default)

	# MUNDO
	add_custom_type_safe("RuichisLab/World/DayNightCycle", "CanvasModulate", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDayNightCycle.gd"), icon_default)
	add_custom_type_safe("RuichisLab/World/Weather", "Node2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteWeather.gd"), icon_default)
	add_custom_type_safe("RuichisLab/World/SoundArea", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteSoundArea.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/DamageZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteDamageZone.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/Bouncer", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteBouncer.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/ParallaxScroll", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteParallaxScroll.gd"), icon_default)
	add_custom_type_safe("RuichisLab/World/ShakeTrigger", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteShakeTrigger.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/LevelPortal", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLevelPortal.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/CameraZone", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCameraZone.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/LightFlicker", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLightFlicker.gd"), icon_default)
	add_custom_type_safe("RuichisLab/World/Teleporter", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteTeleporter.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/AreaEffect", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteAreaEffect.gd"), icon_area)
	add_custom_type_safe("RuichisLab/World/MovingPlatform", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteMovingPlatform.gd"), icon_default)

	# PLATAFORMAS
	add_custom_type_safe("RuichisLab/Platformer/PlatformerController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePlatformerController.gd"), icon_default)

	# CARRERAS
	add_custom_type_safe("RuichisLab/Racing/CarController", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCarController.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Racing/LapManager", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteLapManager.gd"), icon_default)
	add_custom_type_safe("RuichisLab/Racing/Checkpoint", "Area2D", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteCheckpoint.gd"), icon_area)

	# MÓVIL
	add_custom_type_safe("RuichisLab/Mobile/VirtualJoystick", "Control", preload("res://addons/no_code_godot_plugin/Componentes/ComponenteVirtualJoystick.gd"), icon_default)

	# PUZZLE
	add_custom_type_safe("RuichisLab/Puzzle/Pushable", "Node", preload("res://addons/no_code_godot_plugin/Componentes/ComponentePushable.gd"), icon_default)

	print("RuichisLab Framework cargado correctamente.")

func _exit_tree() -> void:
	_remove_current_types()
	_remover_autoloads()

func _registrar_autoloads() -> void:
	_safe_add_autoload("GameManager", "res://addons/no_code_godot_plugin/Autoloads/GameManager.gd")
	_safe_add_autoload("AudioManager", "res://addons/no_code_godot_plugin/Autoloads/AudioManager.gd")
	_safe_add_autoload("SaveManager", "res://addons/no_code_godot_plugin/Autoloads/SaveManager.gd")
	_safe_add_autoload("PoolManager", "res://addons/no_code_godot_plugin/Autoloads/PoolManager.gd")
	_safe_add_autoload("DialogueManager", "res://addons/no_code_godot_plugin/Servicios/DialogueManager.gd")
	_safe_add_autoload("InventarioGlobal", "res://addons/no_code_godot_plugin/Datos/Inventario/InventarioGlobal.gd")
	_safe_add_autoload("DebugConsole", "res://addons/no_code_godot_plugin/Servicios/DebugConsole.gd")
	_safe_add_autoload("GestorMisiones", "res://addons/no_code_godot_plugin/Servicios/GestorMisiones.gd")
	_safe_add_autoload("FloatingTextManager", "res://addons/no_code_godot_plugin/Servicios/FloatingTextManager.gd")
	_safe_add_autoload("UIManager", "res://addons/no_code_godot_plugin/Servicios/UIManager.gd")
	_safe_add_autoload("EventBus", "res://addons/no_code_godot_plugin/Servicios/EventBus.gd")

func _remover_autoloads() -> void:
	_safe_remove_autoload("GameManager")
	_safe_remove_autoload("AudioManager")
	_safe_remove_autoload("SaveManager")
	_safe_remove_autoload("PoolManager")
	_safe_remove_autoload("DialogueManager")
	_safe_remove_autoload("InventarioGlobal")
	_safe_remove_autoload("DebugConsole")
	_safe_remove_autoload("GestorMisiones")
	_safe_remove_autoload("FloatingTextManager")
	_safe_remove_autoload("UIManager")
	_safe_remove_autoload("EventBus")

# Helper seguro para añadir Autoloads sin recursión
func _safe_add_autoload(name: String, path: String) -> void:
	if Engine.has_singleton(name): return
	# Llamamos al método nativo si existe
	if has_method("add_autoload_singleton"):
		self.call("add_autoload_singleton", name, path)

# Helper seguro para remover Autoloads
func _safe_remove_autoload(name: String) -> void:
	# Eliminamos solo si existe, para no ensuciar logs
	# Nota: remove_autoload_singleton remueve de ProjectSettings, no solo de Engine.
	# Sin embargo, para respetar configuraciones de usuario, a veces es mejor no borrar.
	# Si queremos ser "profesionales", debemos limpiar lo que creamos.
	# Verificamos si existe en ProjectSettings antes de intentar borrar
	if ProjectSettings.has_setting("autoload/" + name):
		if has_method("remove_autoload_singleton"):
			self.call("remove_autoload_singleton", name)

func _remove_current_types() -> void:
	# Limpiar todos los tipos registrados por este plugin
	var types = [
		"RuichisLab/Logic/Trigger", "RuichisLab/Logic/InputListener", "RuichisLab/Logic/GameOverListener", "RuichisLab/Logic/PauseListener",
		"RuichisLab/Logic/Interaccion", "RuichisLab/Logic/SimpleDialog", "RuichisLab/Logic/AdvancedDialog", "RuichisLab/Logic/QuestGiver",
		"RuichisLab/Logic/QuestObjective", "RuichisLab/Logic/Key", "RuichisLab/Logic/Door", "RuichisLab/Logic/ItemChest",
		"RuichisLab/Logic/SavePoint", "RuichisLab/Logic/Shop", "RuichisLab/Logic/Timer", "RuichisLab/Logic/SimpleAnimator",
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
	for t in types:
		if has_method("remove_custom_type"):
			self.call("remove_custom_type", t)

func _remove_old_types() -> void:
	# Versiones antiguas para limpiar
	var old_types = [
		"NC_Trigger", "NC_Interaccion", "RuichisLab/Trigger", "RuichisLab/InputListener"
		# ... lista simplificada para ahorrar espacio, en teoría _remove_current_types cubre la mayoría si el nombre coincide
	]
	for t in old_types:
		if has_method("remove_custom_type"):
			self.call("remove_custom_type", t)
