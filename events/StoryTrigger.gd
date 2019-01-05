extends event

var story_data = []
var story_index
var is_typing = false

export(int) var story_number_to_load = 0
export(bool) var is_incidental = true

func _ready() -> void:
	set_process(false)

func _event():
	# Reset
	story_index = 1
	
	var story_number = GameManager.get_story_number()
	
	if is_incidental:
		if story_number_to_load != story_number:
			return false
	
	# Disable player movement
	GameManager.is_interrupted = true
	
	# Get current game story
	story_data = GameManager.story_data[story_number]
	
	HUD.message_show()
	var story = story_data[0]
	HUD.set_message(story[1], story[0])
	HUD.get_node("MessagePanel/ScrollContainer/Message").percent_visible = 0
	$Typewriter.play()
	is_typing = true
	set_process(true)
	
	return true

func _process(delta: float) -> void:
	var message_box = HUD.get_node("MessagePanel/ScrollContainer/Message")
	
	if is_typing:
		# Animating message character
		message_box.percent_visible += delta
		if message_box.percent_visible == 1: # Stop animation
			$Typewriter.stop()
			is_typing = false
	elif Input.is_action_just_released("ui_select"):
		if story_index < story_data.size():
			var story = story_data[story_index]
			HUD.set_message(story[1], story[0])
			message_box.percent_visible = 0
			$Typewriter.play()
			story_index += 1
			is_typing = true
		else:
			if is_incidental:
				GameManager.set_story_number()
			GameManager.is_interrupted = false
			HUD.message_hide()
			set_process(false)