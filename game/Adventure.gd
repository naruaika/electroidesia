extends Node

# TODO: handle multiple player character
export(PackedScene) var player_scene
export(PackedScene) var map_scene

func _ready():
	$Player.add_child(player_scene.instance())
	# TODO: handle savable objects in the map
	reload_map()

func reload_map() -> void:
	# Remove all child
	if $Map.get_child_count() > 0:
		$Map.remove_child($Map.get_child(0))
	
	# Add a child
	$Map.add_child(map_scene.instance())
