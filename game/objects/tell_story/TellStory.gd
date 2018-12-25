extends Area

export(int) var story_number

func _on_TellStory_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if GameManager.data["story"] == story_number:
			GameManager.tell_story()
