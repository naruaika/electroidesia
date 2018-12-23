extends Control

func _ready():
	$Menu/Buttons/NewGameButton.grab_focus()
	for button in $Menu/Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.go_to_scene])

func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)