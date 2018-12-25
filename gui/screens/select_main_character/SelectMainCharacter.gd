extends Control

# TODO: handle custom character name
func _ready() -> void:
	$Buttons/SelectNaru.grab_focus()
	for button in $Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(chosen_character):
	GameManager.set_player_name($Name.text)
	GameManager.set_player_character(chosen_character)
	GameManager.goto_scene("res://game/Adventure.tscn")