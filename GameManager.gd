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
	goto_scene("res://maps/ElectroidesiaForest.tscn")

func load_game() -> void:
	pass

"""
	Handle game adventure
"""
var _user_data = {
	"player_name" : "",
	"character_name" : "",
	"hit_point" : [0.0, 0.0],
	"mana_point" : [0.0, 0.0],
	"experience_point" : [0.0, 0.0],
	"weapon_name" : "",
	"weapon_elemental" : "",
	"weapon_physical_attack" : 0.0,
	"weapon_physical_defense" : 0.0,
	"weapon_magical_attack" : 0.0,
	"weapon_magical_defense" : 0.0,
	"skills" : [],
	"backpack" : [],
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

func set_character(char_name: String, hp: float, mp: float) -> void:
	_user_data["character_name"] = char_name
	_user_data["hit_point"][0] = hp
	_user_data["hit_point"][1] = hp
	_user_data["mana_point"][0] = mp
	_user_data["mana_point"][1] = mp

func set_player_hp(current_hp: float, max_hp: float = 0) -> void:
	_user_data["hit_point"][0] = current_hp
	if max_hp > 0:
		_user_data["hit_point"][1] = max_hp
	
	var player_statistics = GameManager.get_player_statistics()
	HUD.set_player_statistics(player_statistics[0], player_statistics[1])

func set_weapon(wp_name: String, wp_el: String, wp_pa: float, wp_pd: float, wp_ma: float, wp_md: float) -> void:
	_user_data["weapon_name"] = wp_name
	_user_data["weapon_elemental"] = wp_el
	_user_data["weapon_physical_attack"] = wp_pa
	_user_data["weapon_physical_defense"] = wp_pd
	_user_data["weapon_magical_attack"] = wp_ma
	_user_data["weapon_magical_defense"] = wp_md

func get_player_statistics() -> Array:
	return [_user_data["hit_point"], _user_data["mana_point"]]

func set_story_number(number: int) -> void:
	_user_data["story_number"] = number

func get_story_number() -> int:
	return int(_user_data["story_number"])