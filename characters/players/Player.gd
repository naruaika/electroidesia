extends Character

signal attack_ended()

var type: String
var hit_point = [0.0, 0.0]
var mana_point = [0.0, 0.0]
var experience_point = [0.0, 0.0]
var elemental: String
var attack_point = [0.0, 0.0]
var defense_point = [0.0, 0.0]
var level: int = 1

onready var weapon_node = $Skeleton/Weapon

const SPEED = 18
const GRAVITATION = -9.8 * 2

var velocity = Vector3()
var is_attacking = false

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	# Set character player statistics
	var player_statistics = GameManager.characters_stats_data[character_name]
	type = player_statistics["type"]
	hit_point[1] = player_statistics["hit_point"]
	mana_point[1] = player_statistics["mana_point"]
	experience_point[1] = pow(level, 3) * 8 + pow(level + 1, 2) * 11
	
	var weapon_statistics = GameManager.weapons_stats_data[weapon_node.weapon_name]
	elemental = weapon_statistics["elemental"]
	attack_point[0] = weapon_statistics["attack"][0]
	attack_point[1] = weapon_statistics["attack"][1]
	defense_point[0] = weapon_statistics["defense"][0]
	defense_point[1] = weapon_statistics["defense"][1]
	
	# FIXME: handle retention
	hit_point[0] = hit_point[1]
	mana_point[0] = mana_point[1]

func _physics_process(delta: float) -> void:
	if not GameManager.is_interrupted:
		process_movement(delta)
	else:
		# Play character idle animation
		# if current_animation != "idle"
		if $AnimationPlayer.current_animation != "idle" and not is_attacking:
			$AnimationPlayer.play("idle")
			
			# Reset velocity
			velocity = Vector3()

func process_movement(delta: float) -> void:
	var direction = Vector3()
	var camera_xform = camera.global_transform
	var is_moving = false

	# Get movement input from player
	if Input.is_action_pressed("movement_forward"):
		direction -= camera_xform.basis[2]
		is_moving = true
	if Input.is_action_pressed("movement_backward"):
		direction += camera_xform.basis[2]
		is_moving = true
	if Input.is_action_pressed("movement_right"):
		direction += camera_xform.basis[0]
		is_moving = true
	if Input.is_action_pressed("movement_left"):
		direction -= camera_xform.basis[0]
		is_moving = true
	
	direction.y = 0
	direction = direction.normalized()
	
	# Make character interacts with static "gravitation"
	velocity.y = GRAVITATION
	
	# Make smooth character movement
	velocity = velocity.linear_interpolate(direction * SPEED, 10 * delta)
	
	# Make movement to character
	velocity = move_and_slide(velocity, Vector3(0, 1, 0), 0.05, 4, deg2rad(70))
	
	if is_moving:
		# If character is moving then
		# make rotation to player's face
		rotation.y = atan2(velocity.x, velocity.z)
		
		# Play character run animation
		# if current_animation != "run"
		if $AnimationPlayer.current_animation != "run":
			$AnimationPlayer.play("run")
	else:
		# Play character idle animation
		# if current_animation != "idle"
		if $AnimationPlayer.current_animation != "idle":
			$AnimationPlayer.play("idle")

func attack(enemy_node: Node) -> void:
	is_attacking = true
	
	# Add damage to selected enemy
	damage_point = attack_point[0]
	enemy_node.attacked(damage_point)
	$AnimationPlayer.play("slash", -1, 2)
	target_node = enemy_node
	
	yield($AnimationPlayer, "animation_finished")
	
	is_attacking = false
	emit_signal("attack_ended")

func attacked(damage_point: float) -> void:
	hit_point[0] -= damage_point
	
	HUD.set_player_statistics(hit_point, mana_point)

func level_up(gained_experience_point: float) -> void:
	experience_point[0] += gained_experience_point
	
	while experience_point[0] >= experience_point[1]:
		level += 1
		experience_point[1] = pow(level, 3) * 8 + pow(level + 1, 2) * 11
		
		hit_point[1] = round(hit_point[1] + pow(hit_point[1], 0.333) * 2.5)
		mana_point[1] = round(mana_point[1] + pow(mana_point[1], 0.5) * 1.5)
		
		hit_point[0] = hit_point[1]
		mana_point[0] = mana_point[1]
		
		HUD.set_player_statistics(hit_point, mana_point)