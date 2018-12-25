extends Character

const SPEED = 20
const ACCELERATION = 3
const DEACCELERATION = 5
const GRAVITATION = -9.8

var velocity = Vector3()

func _physics_process(delta: float) -> void:
	if !GameManager.is_interrupted:
		process_movement(delta)

func process_movement(delta: float) -> void:
	var direction = Vector3()
	var camera_xform = camera.get_global_transform()

	var is_moving = false

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
	
	velocity.y = GRAVITATION
	
	var horizontal_velocity = velocity
	horizontal_velocity.y = 0
	
	var new_position = direction * SPEED
	var accelerate = ACCELERATION if direction.dot(horizontal_velocity) > 0 else DEACCELERATION
	
	horizontal_velocity = horizontal_velocity.linear_interpolate(new_position, accelerate * delta)
	
	velocity.x = horizontal_velocity.x
	velocity.z = horizontal_velocity.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if is_moving:
		# FIXME: Character rotation bug while colliding with any wall
		var angle = atan2(horizontal_velocity.x, horizontal_velocity.z)
		var character_rotation = rotation
		
		character_rotation.y = angle
		rotation = character_rotation
	
	# Point camera to player
	# TODO: make it more flexible
	camera.translation.x = translation.x
	camera.translation.z = translation.z + 18
