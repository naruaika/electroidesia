extends Control

func _ready() -> void:
	# Set default focus to NewGameButton
	$VBoxContainer/Buttons/NewGameButton.grab_focus()
	
	# Connect all buttons to play()
	for button in $VBoxContainer/Buttons.get_children():
		button.connect("pressed", self, "play", [button.scene_to_load])
	
	if GameManager.user_setting["background_music"]:
		GameManager.get_node("BGM/TitleScreen").play()

func play(scene_to_load: String) -> void:
	# Play fade_out animation
	$AnimationPlayer.play("fade_out")
	
	# Wait until fade_out animation finished
	yield($AnimationPlayer, "animation_finished")
	
	# Replace this scene to scene_to_load
	GameManager.goto_scene(scene_to_load)