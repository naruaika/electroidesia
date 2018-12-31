extends Node

"""
	Handle scene changing
"""
var current_scene = null

func _ready() -> void:
	var root = get_node("/root")
	current_scene = root.get_child(root.get_child_count() - 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func goto_scene(path: String) -> void:
	# Load resource from the given path interactively
	var loader = ResourceLoader.load_interactive(path)
	
	# Remove current scene from the tree
	current_scene.queue_free()
	
	# Wait until the resource has finished loading
	var time_max = 100 # in msec
	while OS.get_ticks_msec() < OS.get_ticks_msec() + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF: # == load finished
			current_scene = loader.get_resource().instance()
			get_node("/root").call_deferred("add_child", current_scene)
			loader = null
			break
		elif err == OK: # == loading
			continue
		else: # == error during loading
			loader = null
			break

"""
	Handle first game appearance
"""
func new_game() -> void:
	goto_scene("res://maps/Firstland.tscn")

func load_game() -> void:
	pass

"""
	Handle game adventure
"""
var player_name: String = ""