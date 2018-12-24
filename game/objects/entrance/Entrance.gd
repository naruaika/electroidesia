extends MeshInstance

export(String, "North", "West", "South", "East") var enter_direction = "North"
export(bool) var auto_enter = true
export(String) var go_to_scene = "res://.tscn"

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if auto_enter or Input.is_action_just_pressed("ui_accept"):
			GameManager.go_to_scene(go_to_scene, enter_direction)

func get_spawn_position() -> Vector3:
	return $SpawnPoint.global_transform.origin
