extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().change_scene("res://gui/screens/title_screen/TitleScreen.tscn")
