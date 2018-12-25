extends Control

func _ready() -> void:
	$Menu/Buttons/NewGameButton.grab_focus()

func _on_NewGameButton_pressed() -> void:
	GameManager.start_game(true)

func _on_ContinueButton_pressed() -> void:
	GameManager.start_game(false)