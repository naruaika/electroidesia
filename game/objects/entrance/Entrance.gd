extends MeshInstance

export(String, "North", "West", "South", "East") var enter_direction = "North"
export(bool) var auto_enter = true
export(String) var go_to_scene = "res://.tscn"
export(bool) var enable = true

func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("player") and enable:
		if auto_enter or Input.is_action_just_pressed("ui_accept"):
			GameManager.goto_map(go_to_scene, enter_direction)

func get_spawn_position() -> Vector3:
	return $SpawnPoint.global_transform.origin
