extends Area

export(int) var story_number = 0
export(bool) var auto_narrate = false
export(String) var default_dialogue = ""

func _ready() -> void:
	set_process(false)

func _on_StoryArea_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if auto_narrate:
			if GameManager.data["story"] == story_number:
				StoryManager.tell_story()
		else:
			set_process(true)

func _on_StoryArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		set_process(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if GameManager.data["story"] == story_number:
			StoryManager.tell_story()
		else:
			StoryManager.tell_story([default_dialogue, get_parent().get_name()])
		set_process(false)