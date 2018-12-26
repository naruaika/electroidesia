extends Node

func _ready() -> void:
	$Player.add_child(load(GameManager.get_player_character()).instance())
	# TODO: handle savable objects in the map
	reload_map()

func reload_map() -> void:
	# Remove all child
	if $Map.get_child_count() > 0:
		$Map.remove_child($Map.get_child(0))
	
	# Add a child
	# FIXME: handle big map
	$Map.add_child(load(GameManager.get_map()).instance())
	StoryManager.reset_environment()
