extends Control

var dialogue_index
var story

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if GameManager.is_telling_story:
		if event.is_action_released("ui_accept"):
			dialogue_index += 1
			if dialogue_index == story.size():
				$Dialogue.hide()
				GameManager.is_telling_story = false
				set_process_input(false)
			else:
				$Dialogue/Name.text = story[dialogue_index][1]
				$Dialogue/Content.text = story[dialogue_index][0]

func tell_story(no: String) -> void:
	story = GameManager.game_story[no]
	$Dialogue/Name.text = story[0][1]
	$Dialogue/Content.text = story[0][0]
	
	$Dialogue.show()
	GameManager.is_telling_story = true
	set_process_input(true)
	dialogue_index = 1