extends Spatial

# TODO: handle multiple player character
export(PackedScene) var player_scene
export(PackedScene) var map_scene

func _ready():
	$Player.add_child(player_scene.instance())
	# TODO: handle savable objects in the map
	$Map.add_child(map_scene.instance())
