extends event

var index_battler = 0
var battlers = []

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if battlers[index_battler].is_in_group("player"):
		if Input.is_action_just_pressed("ui_accept"):
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

func combat() -> void:
	if battlers[index_battler].is_in_group("enemy"):
		battlers[index_battler].attack(battlers[0])
	else:
		battlers[index_battler].attack(battlers[1])
	
	if index_battler == 0:
		yield(battlers[index_battler], "attack_ended")
	# Check if no more active enemies or players
	if battlers[1].hit_point[0] <= 0:
		yield(get_tree().create_timer(1.0), "timeout")
		battlers[1].queue_free()
		battlers.remove(1)
	var active_enemy_exist = false
	for battler in battlers:
		if battler.is_in_group("enemy"):
			active_enemy_exist = true
			break
	if active_enemy_exist:
		change_battler()
	else:
		GameManager.is_interrupted = false
		battlers[0].get_node("Skeleton/Weapon").visible = false
		HUD.battle_hide()
		queue_free()

func change_battler() -> void:
	index_battler += 1
	if index_battler >= battlers.size():
		index_battler = 0
	
	if battlers[index_battler].is_in_group("enemy"):
		$Timer.start(1.0)
		HUD.attack_menu_hide()
	else:
		HUD.attack_menu_show()