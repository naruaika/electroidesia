extends KinematicBody

class_name Character

export var character_name: String

var target_node
var damage_point

func show_damage() -> void:
	var damage_text = load("res://game_ui/hud/DamageText.tscn").instance()
	var target_position = get_node("/root").get_camera().unproject_position(target_node.global_transform.origin)
	damage_text.text = str(damage_point)
	damage_text.rect_position = Vector2(target_position.x - (damage_text.rect_size.x / 2), target_position.y - (damage_text.rect_size.y / 2))
	get_node("/root/HUD").add_child(damage_text)
