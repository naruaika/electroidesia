extends MeshInstance

export(String) var weapon_name = ""
export(float) var weapon_physical_attack = 0.0
export(float) var weapon_physical_defense = 0.0
export(float) var weapon_magical_attack = 0.0
export(float) var weapon_magical_defense = 0.0
export(String, "Water") var weapon_elemental = "Water"

func _ready() -> void:
	GameManager.set_weapon(weapon_name, weapon_elemental, weapon_physical_attack, weapon_physical_defense, weapon_magical_attack, weapon_magical_defense)