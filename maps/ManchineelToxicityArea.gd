extends Area

var player_node
var wind_direction_to_east = false

func _ready() -> void:
	set_physics_process(false)

func _on_ManchineelToxicityArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_node = body
		set_physics_process(true)
		HUD.battle_show()

func _on_ManchineelToxicityArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		set_physics_process(false)
		HUD.battle_hide()

func _physics_process(delta: float) -> void:
	if wind_direction_to_east:
		player_node.attacked(0.1)

func _on_Timer_timeout() -> void:
	var number = randi() % 2
	if number == 0:
		wind_direction_to_east = false
		$Weathervane/Top.rotation_degrees = Vector3(0, 90, 0)
	else:
		wind_direction_to_east = true
		$Weathervane/Top.rotation_degrees = Vector3(0, -90, 0)
