extends TextureButton

export var scene_to_load: String = ""

func _on_MenuButton_focus_entered() -> void:
	$ButtonFocus.play()
	$Label.set("custom_colors/font_color", Color("#fdefba"))

func _on_MenuButton_focus_exited() -> void:
	$Label.set("custom_colors/font_color", Color("#000"))

func _on_MenuButton_pressed() -> void:
	$ButtonPress.play()
