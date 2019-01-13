extends Spatial

export var knowledge_name: String = ""

var is_learning = false

func _ready() -> void:
	set_process_input(false)

func _on_LearningTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		set_process_input(true)

func _on_LearningTrigger_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if not is_learning:
			set_process_input(false)

func _input(event: InputEvent) -> void:
	var container = HUD.get_node("InvestigationPanel/ScrollContainer")
	var scroll_height = 31
	
	if event.is_action_pressed("ui_accept"):
		if is_learning:
			is_learning = false
			GameManager.is_interrupted = false
			HUD.investigation_hide()
		elif not GameManager.is_interrupted:
			is_learning = true
			GameManager.is_interrupted = true
			container.scroll_vertical = 0
			HUD.set_description(GameManager.knowledges_data[knowledge_name])
			HUD.investigation_show()
	elif Input.is_action_pressed("movement_backward"):
		container.scroll_vertical += scroll_height
	elif Input.is_action_pressed("movement_forward"):
		container.scroll_vertical -= scroll_height