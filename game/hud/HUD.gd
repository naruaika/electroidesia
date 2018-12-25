extends Control

var dialogue_index
var story

func _ready() -> void:
	set_process_input(false)

func _input(event: InputEvent) -> void:
	if GameManager.is_interrupted:
		if event.is_action_released("ui_accept"):
			dialogue_index += 1
			if dialogue_index == story.size():
				$Dialogue.hide()
				GameManager.is_interrupted = false
				set_process_input(false)
			else:
				$Dialogue/Name.text = story[dialogue_index][1]
				$Dialogue/Content.text = story[dialogue_index][0]

func show_dialogues(game_story: Array) -> void:
	story = game_story
	$Dialogue/Name.text = story[0][1]
	$Dialogue/Content.text = story[0][0]
	
	$Dialogue.show()
	GameManager.is_interrupted = true
	set_process_input(true)
	dialogue_index = 0