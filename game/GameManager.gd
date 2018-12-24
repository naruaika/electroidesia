extends Node

var opposite_direction = {
	"North" : "South",
	"South" : "North",
	"East" : "West",
	"West" : "East"
}

func go_to_scene(scene_path : String, enter_direction : String):
	var adventure_node = get_tree().get_root().get_child(1)
	
	# Change map scene
	var old_map_scene_path = adventure_node.map_scene.get_path()
	adventure_node.map_scene = load(scene_path)
	adventure_node.reload_map()
	
	# Reset player position
	#----- Find match spawn point
	var entrances_node = adventure_node.get_node("Map").get_child(0).get_node("Entrances")
	var spawn_position
	for point in entrances_node.get_children():
		if point.go_to_scene == old_map_scene_path and opposite_direction[point.enter_direction] == enter_direction:
			spawn_position = point.get_spawn_position()
			break
	# Change player position to spawn_position
	var player_node = adventure_node.get_node("Player").get_child(1)
	player_node.global_transform.origin = spawn_position