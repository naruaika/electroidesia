extends Area

var player_node
var wind_direction_to_east = false

func _ready() -> void:
	set_physics_process(false)

func _on_ManchineelToxicityArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_node = body
		set_physics_process(true)
		HUD.battle_show(false)

func _on_ManchineelToxicityArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		set_physics_process(false)
		HUD.battle_hide()

var suffer_timer = 0
func _physics_process(delta: float) -> void:
	if not GameManager.is_locked:
		if wind_direction_to_east:
			suffer_timer += 1
			if suffer_timer == 20:
				player_node.attacked(2)
				suffer_timer = 0
		else:
			suffer_timer = 0

func _on_Timer_timeout() -> void:
	if wind_direction_to_east:
		wind_direction_to_east = false
		$Weathervane/Top.rotation_degrees = Vector3(0, 90, 0)
		$Weathervane/Squeak.play()
	else:
		wind_direction_to_east = true
		$Weathervane/Top.rotation_degrees = Vector3(0, -90, 0)
		$Weathervane/Squeak.play()
	
	$Particles.emitting = wind_direction_to_east
