extends event

var camera_velocity = Vector3()

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	set_physics_process(false)

func _on_BattleArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Disable player movement
		GameManager.is_interrupted = true
		
		HUD.battle_show()
		
		set_physics_process(true)
		
		# Get player character in root tree
		var player = get_tree().get_nodes_in_group("player")[0]
		
		# Get player current position
		var player_position = player.translation
		
		# Get monster character in this parent node
		# The parent node is always enemy node
		var enemy = get_parent()
		
		# Get enemy current position
		var enemy_position = enemy.translation
		
		# Set this enemy to points the first player
		enemy.look_at(player_position, Vector3(0, 1, 0))
		enemy.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		# Set player to points the first enemy
		player.look_at(enemy_position, Vector3(0, 1, 0))
		player.global_rotate(Vector3(0, 1, 0), deg2rad(180))
		
		camera_velocity = camera.translation

func _physics_process(delta: float) -> void:
	# Get player current position
	var player_position = get_tree().get_nodes_in_group("player")[0].translation
	
	# Get enemy current position
	var enemy_position = get_parent().translation
	
	# Get mid point between player position and enemy position
	var middle_point = Vector3((player_position.x + enemy_position.x) / 2, (player_position.y + enemy_position.y) / 2, (player_position.z + enemy_position.z) / 2)
	
	camera_velocity = camera_velocity.linear_interpolate(middle_point, 2 * delta)
	
	# Set camera to points the middle point
	camera.translation.x = camera_velocity.x
	camera.translation.z = camera_velocity.z + 50
	camera.translation.y = camera_velocity.y + 55