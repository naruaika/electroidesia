extends Node

# Current game data
var current_scene = null
var data = {
	# TODO: handle multiple player character
	player = "res://game/characters/player/naru/Naru.tscn",
	map    = "res://game/maps/initial_map/InitialMap.tscn",
	story  = 1
}
var is_telling_story = false
var _story_path = "game/story/story.dat"

# References
var opposite_direction = {
	"North" : "South",
	"South" : "North",
	"East"  : "West",
	"West"  : "East"
}
var game_story

func new_game() -> void:
	# Start game
	goto_scene("res://game/Adventure.tscn")
	
	# Reset player position
#	var players = get_tree().get_nodes_in_group("player")
#	for player in players:
#		player.translation = Vector3(-27, 0, 47)

func go_to_map(scene_path: String, enter_direction: String) -> void:
	var adventure_node = get_tree().get_root().get_node("Adventure")
	
	# Change map scene
	var previous_scene_path = data["map"]
	data["map"] = scene_path
	adventure_node.reload_map()
	
	# Reset player position
	#----- Find match spawn point
	var entrances_node = adventure_node.get_node("Map").get_child(0).get_node("Entrances")
	var spawn_position
	for point in entrances_node.get_children():
		if point.go_to_scene == previous_scene_path and opposite_direction[point.enter_direction] == enter_direction:
			spawn_position = point.get_spawn_position()
			break
	#----- Change player position to spawn_position
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.global_transform.origin = spawn_position

func tell_story():
	get_tree().get_root().get_node("Adventure/HUD").tell_story(str(data["story"]))
	data["story"] += 1

func _ready() -> void:
	# Get current scene
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	# Load story file
	var f = File.new()
	f.open(_story_path, File.READ)
	game_story = parse_json(f.get_as_text())
	f.close()

func goto_scene(path) -> void:
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path) -> void:
	current_scene.free()
	current_scene = ResourceLoader.load(path).instance()
	get_tree().get_root().add_child(current_scene)
	# Optional
	get_tree().set_current_scene(current_scene)

#var loader
#var wait_frames
#var time_max = 100 # msec
#var current_scene
#
#func _ready() -> void:
#	var root = get_tree().get_root()
#	current_scene = root.get_child(root.get_child_count() -1)
#
#func goto_scene(path) -> void: # game requests to switch to this scene
#	loader = ResourceLoader.load_interactive(path)
#	if loader == null: # check for errors
#		show_error()
#		return
#	set_process(true)
#
#	current_scene.queue_free() # get rid of the old scene
#
#	# start your "loading..." animation
#	get_node("animation").play("loading")
#
#	wait_frames = 1

#func set_new_scene(scene_resource) -> void:
#    current_scene = scene_resource.instance()
#    get_node("/root").add_child(current_scene)