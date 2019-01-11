extends event

signal story_ended()

var story_data = []
var dialogue_index = 0
var current_dialogue
var is_typing = false

export var story_number: int = -1
export var next_story_number: int = -1

var animation_story
var has_animation: bool = false

func _ready() -> void:
	set_process(false)

func _event() -> bool:
	if story_number != GameManager.get_story_number():
		return false
	
	# Disable player movement
	GameManager.is_interrupted = true
	
	animation_story = get_child(1)
	# Play animation before
	if animation_story:
		if animation_story.has_animation("before"):
			animation_story.play("before")
			yield(animation_story, "animation_finished")
	# Get current game story
	story_data = GameManager.story_data[story_number]
	
	# Show dialogues
	HUD.message_show()
	get_next()
	set_process(true)
	
	return true

func _process(delta: float) -> void:
	var message_box = HUD.get_node("MessagePanel/ScrollContainer/Message")
	
	if is_typing:
		# Animate message typing
		message_box.visible_characters += 1
		
		if message_box.visible_characters == current_dialogue[1].length() or Input.is_action_just_released("ui_accept"): # Stop
			message_box.visible_characters = current_dialogue[1].length()
			stop_typing()
	elif Input.is_action_just_released("ui_accept"):
		if dialogue_index < story_data.size():
			get_next()
		else: # Finish
			# Play animation after
			if animation_story:
				if animation_story.has_animation("after"):
					animation_story.play("after")
					yield(animation_story, "animation_finished")
			
			# Set next story number to be loaded
			if next_story_number != -1:
				GameManager.set_story_number(next_story_number)
			else:
				GameManager.set_story_number(story_number + 1)
			
			# Enable player movement
			GameManager.is_interrupted = false
			
			# Hide dialogues
			HUD.message_hide()
			set_process(false)
			
			emit_signal("story_ended")

func get_next() -> void:
	current_dialogue = story_data[dialogue_index]
	HUD.set_message(current_dialogue[1], current_dialogue[0])
	dialogue_index += 1
	
	# Animate
	GameManager.get_node("SFX/Typewriter").play()
	is_typing = true

func stop_typing() -> void:
	GameManager.get_node("SFX/Typewriter").stop()
	is_typing = false