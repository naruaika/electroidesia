extends KinematicBody

const SPEED = 15
const GRAVITATION = -9.8 * 2

var velocity = Vector3()

onready var camera = get_node("/root").get_camera()

func _physics_process(delta: float) -> void:
	if not GameManager.is_interrupted:
		process_movement(delta)
	else:
		# Play character idle animation
		# if current_animation != "idle"
		if $AnimationPlayer.current_animation != "idle":
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
	
