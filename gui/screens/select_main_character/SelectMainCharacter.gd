extends Control

# TODO: handle custom character name
func _ready() -> void:
	$Buttons/SelectNaru.grab_focus()
	for button in $Buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load, button.character_name])

func _on_Button_pressed(character_scene: String, character_name: String) -> void:
	GameManager.set_player_name(character_name, $CustomName.text)
	GameManager.set_player_character(character_scene)
	GameManager.goto_scene("res://game/Adventure.tscn")