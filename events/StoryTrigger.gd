extends event

var story_data = []
var story_index = 1

export(int) var story_number_to_load = 0
export(bool) var is_incidental = true

func _ready() -> void:
	set_process_input(false)

func _event():
	var story_number = GameManager.get_story_number()
	
	if is_incidental:
		if story_number_to_load < story_number:
			return false
	
	# Disable player movement
	GameManager.is_interrupted = true
	
	# Get current game story
	story_data = GameManager.story_data[story_number]
	
	# Show current game story
	HUD.get_node("MessagePanel").visible = true
	HUD.get_node("MessagePanel/Speaker").text = story_data[0][0]
	HUD.get_node("MessagePanel/Message").text = story_data[0][1]
	set_process_input(true)
	
	return true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select"):
		if story_index < story_data.size():
			HUD.get_node("MessagePanel/Speaker").text = story_data[story_index][0]
			HUD.get_node("MessagePanel/Message").text = story_data[story_index][1]
			story_index += 1
		else:
			GameManager.set_story_number()
			GameManager.is_interrupted = false
			HUD.get_node("MessagePanel").visible = false
			set_process_input(false)