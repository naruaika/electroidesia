extends Area

class_name event

export(bool) var enable = true

func _on_EventTrigger_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if enable:
			_event()

func _event() -> bool:
	return true
