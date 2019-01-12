extends Control

onready var animation_node = $AnimationPlayer

var attack_menu_focus = false

func set_message(message: String, speaker: String = "") -> void:
	$MessagePanel/ScrollContainer/Message.text = message
	$MessagePanel/ScrollContainer/Message.visible_characters = 0
	$MessagePanel/Speaker.text = GameManager.get_player_name() if speaker == "Aleace" else speaker
	$MessagePanel/Photo.texture = load("res://assets/gui/hud/" + speaker + ".png")

func set_description(description: String) -> void:
	$InvestigationPanel/ScrollContainer/Description.text = description

func battle_show() -> void:
	animation_node.play("battle_show")
	$BattlePanel/HBoxContainer/Menu/AttackButton.grab_focus()
	attack_menu_focus = true

func battle_hide() -> void:
	animation_node.play("battle_hide")

func attack_menu_show() -> void:
	$BattlePanel/HBoxContainer/Menu.get_child(0).grab_focus()
	attack_menu_focus = true
	animation_node.play("attack_enable")

func attack_menu_hide() -> void:
	# Check if attack menu is already hidden
	if attack_menu_focus != false:
		for button in $BattlePanel/HBoxContainer/Menu.get_children():
			button.release_focus()
		attack_menu_focus = false
		animation_node.play("attack_disable")

func set_player_statistics(hit_point: Array, mana_point: Array) -> void:
	var container = $BattlePanel/HBoxContainer/Container/PLayerList/PlayerStatistics/VBoxContainer/
	container.get_node("HPBar").value = hit_point[0]
	container.get_node("MPBar").value = mana_point[0]
	container.get_node("HPBar/Label").text = str(hit_point[0])
	container.get_node("MPBar/Label").text = str(mana_point[0])
	
	container.get_node("HPBar").max_value = hit_point[1]
	container.get_node("MPBar").max_value = mana_point[1]

func message_show() -> void:
	animation_node.play("message_show")

func message_hide() -> void:
	animation_node.play("message_hide")

func investigation_show() -> void:
	animation_node.play("investigation_show")

func investigation_hide() -> void:
	animation_node.play("investigation_hide")

func levelup_show(gained_experience_point: float) -> void:
	$LevelUpPanel/Container/HBoxContainer/GainedEXP.text = str(gained_experience_point)
	animation_node.play("levelup_show")

func levelup_hide() -> void:
	animation_node.play("levelup_hide")