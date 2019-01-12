extends KinematicBody

signal attack_ended()

export var character_name: String = ""
export var hit_point: float = 0.0
export var mana_point: float = 0.0

const SPEED = 15
const GRAVITATION = -9.8 * 2

var velocity = Vector3()
var is_attacking = false

onready var camera = get_node("/root").get_camera()

func _ready() -> void:
	GameManager.set_character(character_name, hit_point, mana_point)

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
	var camera_xform = camera.get_global_transform()
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

var target_node
var attack_point

func attack(enemy_node: Node) -> void:
	is_attacking = true
	
	# Add damage to enemy
	attack_point = get_node("Skeleton/Weapon").weapon_physical_attack
	enemy_node.attacked(attack_point)
	$AnimationPlayer.play("slash", -1, 2)
	target_node = enemy_node
	
	yield($AnimationPlayer, "animation_finished")
	
	is_attacking = false
	emit_signal("attack_ended")

func show_damage() -> void:
	var damage_text = load("res://game_ui/hud/DamageText.tscn").instance()
	var screen_position = get_node("/root").get_camera().unproject_position(target_node.global_transform.origin)
	damage_text.text = str(attack_point)
	damage_text.rect_position = Vector2(screen_position.x - (damage_text.rect_size.x / 2), screen_position.y - (damage_text.rect_size.y / 2))
	get_node("/root/HUD").add_child(damage_text)