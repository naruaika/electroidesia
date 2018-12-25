extends Control

func _ready() -> void:
	$Menu/Buttons/NewGameButton.grab_focus()

func _on_NewGameButton_pressed() -> void:
	GameManager.new_game()
