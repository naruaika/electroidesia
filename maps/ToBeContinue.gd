extends Area

func _on_ToBeContinue_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GameManager.is_interrupted = true
		$AnimationPlayer.play("fade_in")

func goto_titlescreen() -> void:
	GameManager.goto_scene("res://game_ui/title_screen/TitleScreen.tscn")