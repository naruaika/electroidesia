extends Control

func _ready() -> void:
	# Set default focus to LineEdit
	$VBoxContainer/PlayerName/LineEdit.grab_focus()
	
	# Connect EnterButton to play()
	var button = $VBoxContainer/PlayerName/EnterButton
	button.connect("pressed", self, "play")

func _input(event: InputEvent) -> void:
	# Grab EnterButton focus if "ui_accept" pressed 
	if event.is_action_pressed("ui_accept"):
		$VBoxContainer/PlayerName/EnterButton.grab_focus()

func play() -> void:
	# Check LineEdit if it's empty
	if $VBoxContainer/PlayerName/LineEdit.text:
		# Stop TitleScreen BGM
		GameManager.get_node("BGM/TitleScreen").stop()
		
		# Save inputed character name
		GameManager.set_player_name($VBoxContainer/PlayerName/LineEdit.text)
		
		# Play fade_out animation
		$AnimationPlayer.play("fade_out")
		
		# Wait until fade_out animation finished
		yield($AnimationPlayer, "animation_finished")
		
		# Start game
		GameManager.new_game()
	else:
		$VBoxContainer/PlayerName/LineEdit.grab_focus()
