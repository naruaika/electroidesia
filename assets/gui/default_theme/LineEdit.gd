extends LineEdit

func _on_LineEdit_focus_entered() -> void:
	$LineEditFocus.play()
	
	# Move cursor to the end of inputted text
	caret_position = str(text).length()

func _on_LineEdit_focus_exited() -> void:
	# Capitalise inputted text
	var line = text
	text = line.capitalize()

func _on_LineEdit_text_changed(new_text: String) -> void:
	$LineEditFocus.play()