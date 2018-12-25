extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.goto_scene("res://gui/screens/title_screen/TitleScreen.tscn")
