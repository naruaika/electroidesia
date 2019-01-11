extends event

var index_attack_menu = 0
var battlers = []
var index_battler = 0

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	set_process(false)

func _on_BattleArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Disable player movement
		GameManager.is_interrupted = true
		
		set_process(true)
		
		# Get player character in root tree
		var player = get_tree().get_nodes_in_group("player")[0]
		
		# Add player as battler
		battlers.append(player)
		
		# Get player current position
		var player_position = player.translation
		
		player.get_node("Skeleton/Weapon").visible = true
		
		# Get monster character in this parent node
		# The parent node is always enemy node
		var enemy = get_parent()
		
		# Add enemy as battler
		battlers.append(enemy)
		
		# Get enemy current position
		var enemy_position = enemy.translation
		
		# Set this enemy to points to player
		enemy.look_at(player_position, Vector3(0, 1, 0))
		enemy.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		# Set player to points to enemy
		player.look_at(enemy_position, Vector3(0, 1, 0))
		player.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		# Show player statistics
		var player_statistics = GameManager.get_player_statistics()
		HUD.set_player_statistics(player_statistics[0], player_statistics[1])
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
	
func _process(delta: float) -> void:
	var enemy = get_parent()
	var player = get_tree().get_nodes_in_group("player")[0]
	if enemy.enemy_hit_point <= 0:
		GameManager.is_interrupted = false
		enemy.queue_free()
		player.get_node("Skeleton/Weapon").visible = false
		HUD.battle_hide()
	
	if $EnemyAttackTimer.is_stopped():
		if battlers[index_battler].is_in_group("player"):
			if Input.is_action_just_pressed("movement_backward"):
				index_attack_menu = clamp(index_attack_menu + 1, 0, 2)
			elif Input.is_action_just_pressed("movement_forward"):
				index_attack_menu = clamp(index_attack_menu - 1, 0, 2)
			elif Input.is_action_just_pressed("ui_select"):
				match(index_attack_menu):
					0:
						battlers[index_battler].attack(battlers[1])
						change_battler()
		elif battlers[index_battler].is_in_group("enemy"):
			$EnemyAttackTimer.start(2.0)
			HUD.toggle_attack_menu()

func _on_EnemyAttackTimer_timeout() -> void:
	battlers[index_battler].attack()
	change_battler()
	HUD.toggle_attack_menu()

func change_battler() -> void:
	index_battler += 1
	if index_battler == battlers.size():
		index_battler = 0