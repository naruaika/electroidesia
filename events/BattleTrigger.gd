extends event

var index_battler: int = 0
var battlers: Array = []
var target: Node
var battler_selector: Node

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("movement_right"):
		change_target(1)
	elif Input.is_action_just_pressed("movement_left"):
		change_target(-1)
	elif Input.is_action_just_pressed("ui_accept"):
		set_process_input(false)
		match(HUD.get_node("BattlePanel/HBoxContainer/Menu").get_focus_owner().get_name()):
			"AttackButton":
				combat()
			"TechButton":
				pass
			"ItemButton":
				pass

func start_battle(body: Node) -> void:
	if body.is_in_group("player"):
		# Disable player movement
		GameManager.is_interrupted = true
		
		# Get player character in root tree
		var player = get_tree().get_nodes_in_group("player")[0]
		
		# Add player as battler
		battlers.append(player)
		
		# Get player current position
		var player_position = player.translation
		
		player.get_node("Skeleton/Weapon").visible = true
		
		# Get monster character inside this area
		# monsters are always children of this node
		for child in get_children():
			# Check if the child is enemy node
			# because this node has other childs like CollisionShape, etc.
			if child.is_in_group("enemy"):
				# Add enemy as battler
				battlers.append(child)
				
				# Set this enemy to points to player
				child.look_at(player_position, Vector3(0, 1, 0))
				child.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		# Get enemy current position
		var enemy_position = get_child(2).global_transform.origin
		
		# Set player to points to enemy
		player.look_at(enemy_position, Vector3(0, 1, 0))
		player.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		# Show player statistics
		HUD.set_player_statistics(player.hit_point, player.mana_point)
		HUD.battle_show()
		
		"""
			Set camera to points middle of battlers
		"""
		# Get mid point between player position and enemy position
		var middle_point = Vector3((player_position.x + enemy_position.x) / 2, (player_position.y + enemy_position.y) / 2, (player_position.z + enemy_position.z) / 2)
		
		# Set camera to points the middle point
		camera.translation.x = middle_point.x
		camera.translation.z = middle_point.z + 50
		camera.translation.y = middle_point.y + 55
		
		set_process_input(true)
		
		show_target_selector()

func combat() -> void:
	if battlers[index_battler].is_in_group("player"):
		battlers[index_battler].attack(target)
		battler_selector.hide()
	else:
		battlers[index_battler].attack(battlers[0])
	
	# FIXME: "attack_ended" signal on enemy node is not working
	if battlers[index_battler].is_in_group("player"):
		yield(battlers[index_battler], "attack_ended")
	# Check if no more active enemies or players
	if target.hit_point[0] <= 0:
		# TODO: change this with disappear/exit animation
		yield(get_tree().create_timer(0.5), "timeout")
		target.queue_free()
		battlers.erase(target)
		change_target()
	var active_enemy_exist = false
	for battler in battlers:
		if battler.is_in_group("enemy"):
			active_enemy_exist = true
			break
	if active_enemy_exist:
		change_battler()
	else:
		# End battle
		GameManager.is_interrupted = false
		battlers[0].get_node("Skeleton/Weapon").visible = false
		HUD.battle_hide()
		queue_free()

func change_battler() -> void:
	index_battler += 1
	if index_battler >= battlers.size():
		index_battler = 0
	
	if battlers[index_battler].is_in_group("player"):
		HUD.attack_menu_show()
		battler_selector.show()
		set_process_input(true)
	else:
		$Timer.start(1.0)
		HUD.attack_menu_hide()

func show_target_selector() -> void:
	# Get first enemy
	for battler in battlers:
		if battler.is_in_group("enemy"):
			target = battler
			break
	
	# Instance battler selector for attack target
	battler_selector = load("res://assets/3d/BattlerSelector.tscn").instance()
	battler_selector.global_transform.origin = to_local(target.get_node("AboveHead").global_transform.origin)
	add_child(battler_selector)

func change_target(direction: int = 0) -> void:
	# Get enemy list from battlers
	var enemies = []
	for battler in battlers:
		if battler.is_in_group("enemy"):
			enemies.append(battler)
	
	if enemies.size() > 0:
		# Get index of current target
		var index_target = 0
		for enemy in enemies:
			if enemy == target:
				break
			else:
				index_target += 1
		
		# Get next target
		index_target += direction
		if index_target < 0:
			index_target = enemies.size() - 1
		else:
			index_target %= enemies.size()
		target = enemies[index_target]
		
		battler_selector.global_transform.origin = target.get_node("AboveHead").global_transform.origin