extends Panel

func _ready() -> void:
	set_process(false)
	get_parent().connect("story_ended", self, "show_tutorial")

func show_tutorial() -> void:
	GameManager.is_interrupted = true
	$AnimationPlayer.play("show")
	set_process(true)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("hide")
		GameManager.is_interrupted = false