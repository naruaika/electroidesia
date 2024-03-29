extends Character

signal attack_ended()

var hit_point = [0.0, 0.0]
var attack_point = [0.0, 0.0]
var defense_point = [0.0, 0.0]
export var level: int = 1

func _ready() -> void:
	# Set character enemy statistics
	var enemy_statistics = GameManager.characters_stats_data[character_name]
	hit_point[1] = enemy_statistics["hit_point"]
	attack_point[0] = enemy_statistics["attack"][0]
	attack_point[1] = enemy_statistics["attack"][1]
	defense_point[0] = enemy_statistics["defense"][0]
	defense_point[1] = enemy_statistics["defense"][1]
	
	hit_point[1] = hit_point[1] + level * 10
	hit_point[0] = hit_point[1]
	attack_point[0] = attack_point[0] + round(pow(level, 2.5))
	attack_point[1] = attack_point[0]
	defense_point[0] = defense_point[0] + pow(defense_point[0], 2)
	defense_point[1] = defense_point[0]

func attack(player_node: Node) -> void:
	target_node = player_node
	
	$AnimationPlayer.play("attack", -1, 2)
	yield($AnimationPlayer, "animation_finished")
	
	emit_signal("attack_ended")

func apply_damage() -> void:
	# Add damage to selected enemy
	target_node.attacked(attack_point[0])

func attacked(damage_point: float) -> void:
	hit_point[0] -= damage_point