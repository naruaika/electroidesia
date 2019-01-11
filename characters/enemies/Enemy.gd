extends KinematicBody

export(String) var enemy_name = ""
export(String, "Earth", "Wind", "Fire", "Water") var enemy_elemental = "Earth"
export(float) var enemy_hit_point = 0
export(float) var enemy_attack = 0
export(float) var enemy_defense = 0
export(int) var enemy_level = 1
export(Array) var enemy_skills = []

var enemy_current_hit_point

func _ready() -> void:
	enemy_hit_point = enemy_hit_point + enemy_level * 10
	enemy_attack = enemy_attack + pow(enemy_level, 3)
	enemy_defense = enemy_defense + pow(enemy_defense, 2)
	
	enemy_current_hit_point = enemy_hit_point

func attack() -> void:
	GameManager.set_player_hp(GameManager.get_player_statistics()[0][0] - enemy_attack)

func attacked(attack_point: float) -> void:
	enemy_hit_point -= attack_point