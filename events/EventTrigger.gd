extends Area
class_name event

export(String, "Story") var event_type = "Story"

func _on_EventTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_event()

func _event() -> bool:
	return true
