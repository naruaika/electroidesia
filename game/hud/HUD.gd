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

func _physics_process(delta: float) -> void:
	# Reset player statistics
	$PlayerStatistics/Name.text = GameManager.get_player_name()[1]
	$PlayerStatistics/HitPoint.value = GameManager.get_player_hp()[0]
	$PlayerStatistics/HitPoint.max_value = GameManager.get_player_hp()[1]
	$PlayerStatistics/ManaPoint.value = GameManager.get_player_mp()[0]
	$PlayerStatistics/ManaPoint.max_value = GameManager.get_player_mp()[1]

func show_dialogues(game_story: Array) -> void:
	story = game_story
	$Dialogue/Name.text = story[0][1]
	$Dialogue/Content.text = story[0][0]
	
	$Dialogue.show()
	GameManager.is_interrupted = true
	set_process_input(true)
	dialogue_index = 0