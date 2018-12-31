extends TextureButton

export(String) var scene_to_load = ""

func _on_MenuButton_focus_entered() -> void:
	$ButtonFocus.play()

func _on_MenuButton_pressed() -> void:
	$ButtonPress.play()
