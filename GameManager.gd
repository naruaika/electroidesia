extends Node

func _ready() -> void:
	var root = get_node("/root")
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Load characters initial stats data
	var file = File.new()
	file.open(_characters_stats_path, File.READ)
	characters_stats_data = parse_json(file.get_as_text())
	file.close()
	
	# Load story data
	file = File.new()
	file.open(_story_path, File.READ)
	story_data = parse_json(file.get_as_text())
	file.close()
	
	# Load weapons initial stats data
	file = File.new()
	file.open(_weapons_stats_path, File.READ)
	weapons_stats_data = parse_json(file.get_as_text())
	file.close()
	
	# Load world objects data
	file = File.new()
	file.open(_knowledges_path, File.READ)
	knowledges_data = parse_json(file.get_as_text())
	file.close()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

"""
	Handle scene changing
"""
var current_scene = null

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
func goto_mainmenu() -> void:
	goto_scene("res://game_ui/title_screen/TitleScreen.tscn")

func new_game() -> void:
	goto_scene("res://maps/ElectroidesiaForest.tscn")

func load_game() -> void:
	pass

"""
	Handle game adventure
"""
var _user_data = {
	"player_name" : "",
	"backpack" : [],
	"story_number" : 0.0
}
var user_setting = {
	"background_music" : true
}
var characters_stats_data
var story_data
var weapons_stats_data
var knowledges_data

var _characters_stats_path = "res://game_data/characters_stats.json"
var _story_path = "res://game_data/story.json"
var _weapons_stats_path = "res://game_data/weapons_stats.json"
var _knowledges_path = "res://game_data/knowledges.json"

var is_interrupted = false
var is_locked = false

func set_player_name(new_name: String) -> void:
	_user_data["player_name"] = new_name

func get_player_name() -> String:
	return _user_data["player_name"]

func set_story_number(number: int) -> void:
	_user_data["story_number"] = number

func get_story_number() -> int:
	return int(_user_data["story_number"])