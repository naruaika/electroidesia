extends KinematicBody

signal attack_ended()

export var enemy_name: String = ""
export var hit_point: float = 0
export var physical_attack: float = 0
export var physical_defense: float = 0
export var level: int = 1

var current_hit_point

func _ready() -> void:
	hit_point = hit_point + level * 10
	physical_attack = physical_attack + pow(level, 3)
	physical_defense = physical_defense + pow(physical_defense, 2)
	current_hit_point = hit_point

func attack(player_node: Node) -> void:
	GameManager.set_player_hp(GameManager.get_player_statistics()[0][0] - physical_attack)
	
	var damage_text = load("res://game_ui/hud/DamageText.tscn").instance()
	var screen_position = get_node("/root").get_camera().unproject_position(player_node.global_transform.origin)
	damage_text.text = str(physical_attack)
	damage_text.rect_position = Vector2(screen_position.x - (damage_text.rect_size.x / 2), screen_position.y - (damage_text.rect_size.y / 2))
	get_node("/root/HUD").add_child(damage_text)
	
	emit_signal("attack_ended")

func attacked(attack_point: float) -> void:
	current_hit_point -= attack_point