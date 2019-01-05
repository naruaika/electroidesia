extends TextureButton

func _on_HUDButton_focus_entered() -> void:
	$ButtonFocus.play()

func _on_HUDButton_pressed() -> void:
	$ButtonPress.play()
