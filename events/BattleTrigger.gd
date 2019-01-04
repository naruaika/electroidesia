extends Area

var camera_velocity = Vector3()

func _ready() -> void:
	set_physics_process(false)

func _on_BattleArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_physics_process(true)
		
#		camera_velocity = get_node("/root").get_camera().translation

func _physics_process(delta: float) -> void:
	# Disable player movement
	GameManager.is_interrupted = true
	
	# Get player character in root tree
	var player = get_tree().get_nodes_in_group("player")[0]
	
	# Get monster character in this parent node
	# The parent node is always enemy node
	var enemy = get_parent()
	
	# Get mid point between player position and enemy position
#	var player_position = player.translation
#	var enemy_position = enemy.translation
#	var mid_point = Vector3((player_position.x + enemy_position.x) / 2, (player_position.y + enemy_position.y) / 2, (player_position.z + enemy_position.z) / 2)
	
#	camera_velocity = camera_velocity.linear_interpolate(mid_point, delta)
	
	# Set camera rotation
#	var camera = get_node("/root").get_camera()
#	camera.translation.x = camera_velocity.x
#	camera.translation.z = camera_velocity.z + 50
#	camera.translation.y = camera_velocity.y + 55
	
		# Set this enemy rotation
#		enemy.look_at(body.to_global(translation).inverse(), Vector3(0, 1, 0))
	
	# Set player rotation
#		player.look_at(to_global(translation).inverse(), Vector3(0, 1, 0))
