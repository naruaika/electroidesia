extends Area

export(int) var object_no = 0
export(Array) var dropping_goods = []

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

var scroll_height = 17

func _input(event: InputEvent) -> void:
	var container = HUD.get_node("InvestigationPanel/ScrollContainer")
	
	if event.is_action_pressed("ui_select"):
		if is_learning:
			is_learning = false
			GameManager.is_interrupted = false
			HUD.investigation_hide()
		else:
			is_learning = true
			GameManager.is_interrupted = true
			HUD.investigation_show()
			container.scroll_vertical = 0
			HUD.set_description(GameManager.objects_data[object_no][1])
	elif event.is_action_pressed("ui_down"):
		container.scroll_vertical += scroll_height
	elif event.is_action_pressed("ui_up"):
		container.scroll_vertical -= scroll_height