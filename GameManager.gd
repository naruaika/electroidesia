extends Node

"""
	Handle scene changing
"""
var current_scene = null

func _ready() -> void:
	var root = get_node("/root")
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Load story data
	var file = File.new()
	file.open(_story_path, File.READ)
	story_data = parse_json(file.get_as_text())
	file.close()
	
	# Load world objects data
	file = File.new()
	file.open(_objects_path, File.READ)
	objects_data = parse_json(file.get_as_text())
	file.close()

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
	story_data = parse_json(to_json(story_data).replace("Aleace", get_player_name()))

func load_game() -> void:
	goto_scene("res://maps/Firstland.tscn")

"""
	Handle game adventure
"""
var _user_data = {
	"player_name" : "",
	"story_number" : 0.0
}
var story_data
var objects_data

var _story_path = "game_data/story.dat"
var _objects_path = "game_data/objects.dat"

var is_interrupted = false

func set_player_name(new_name: String) -> void:
	_user_data["player_name"] = new_name

func get_player_name() -> String:
	return _user_data["player_name"]

func set_story_number() -> void:
	_user_data["story_number"] += 1

func get_story_number() -> int:
	return int(_user_data["story_number"])