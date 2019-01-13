extends Control

onready var animation_node = $AnimationPlayer

var attack_menu_focus = false

func set_message(message: String, speaker: String = "") -> void:
	$MessagePanel/Photo.texture = load("res://assets/gui/hud/" + speaker + ".png")
	
	# Synchronise story data with custom player name
	var player_name = GameManager.get_player_name()
	message = message.replace("Aleace", player_name)
	speaker = speaker.replace("Aleace", player_name)
	
	$MessagePanel/Speaker.text = speaker
	$MessagePanel/ScrollContainer/Message.text = message
	$MessagePanel/ScrollContainer/Message.visible_characters = 0

func set_description(description: String) -> void:
	$InvestigationPanel/ScrollContainer/Description.text = description

func battle_show() -> void:
	animation_node.play("attack_enable")
	yield(animation_node, "animation_finished")
	
	animation_node.play("battle_show")
	$BattlePanel/HBoxContainer/Menu/AttackButton.grab_focus()
	attack_menu_focus = true

func battle_hide() -> void:
	animation_node.play("battle_hide")

func attack_menu_show() -> void:
	if not attack_menu_focus:
		$BattlePanel/HBoxContainer/Menu.get_child(0).grab_focus()
		attack_menu_focus = true
		animation_node.play("attack_enable")

func attack_menu_hide() -> void:
	# Check if attack menu is already hidden
	if attack_menu_focus:
		for button in $BattlePanel/HBoxContainer/Menu.get_children():
			button.release_focus()
		attack_menu_focus = false
		animation_node.play("attack_disable")

func set_player_statistics(hit_point: Array, mana_point: Array) -> void:
	var container = $BattlePanel/HBoxContainer/Container/PlayerList/PlayerStatistics/VBoxContainer/
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

func levelup_show(gained_experience_point: float, players: Array) -> void:
	$LevelUpPanel/CenterContainer/HBoxContainer/GainedEXP.text = str(gained_experience_point)
	animation_node.play("levelup_show")
	
	# TODO: make this dynamic
	var container = $LevelUpPanel/PlayerList/PlayerStatistics
	container.get_node("Photo").texture = load("res://assets/gui/hud/" + players[0].character_name + ".png")
	container.get_node("HBoxContainer/CurrentLevel").text = str(players[0].level)
	container.get_node("EXPBar").value = players[0].experience_point[0]
	container.get_node("EXPBar").max_value = players[0].experience_point[1]

func levelup_hide() -> void:
	animation_node.play("levelup_hide")