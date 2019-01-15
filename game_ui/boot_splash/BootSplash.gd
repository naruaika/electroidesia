extends Control

func _ready() -> void:
	# Hide OS mouse cursor
	# Because we don't need any mouse input in this entire game
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameManager.goto_mainmenu()
		

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	GameManager.goto_scene("res://game_ui/title_screen/TitleScreen.tscn")