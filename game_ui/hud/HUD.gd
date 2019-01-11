extends Control

var attack_menu_focus = false

func set_message(message: String, speaker: String = "") -> void:
	$MessagePanel/ScrollContainer/Message.text = message
	$MessagePanel/ScrollContainer/Message.visible_characters = 0
	$MessagePanel/Speaker.text = speaker
	$MessagePanel/Photo.texture = load("res://assets/gui/hud/" + speaker + ".png")

func set_description(description: String) -> void:
	$InvestigationPanel/ScrollContainer/Description.text = description

func battle_show() -> void:
	$AnimationPlayer.play("battle_show")
	$BattlePanel/HBoxContainer/Menu/AttackButton.grab_focus()
	attack_menu_focus = true

func battle_hide() -> void:
	$AnimationPlayer.play("battle_hide")

func toggle_attack_menu() -> void:
	var menu = $BattlePanel/HBoxContainer/Menu
	if attack_menu_focus:
		for button in $BattlePanel/HBoxContainer/Menu.get_children():
			button.release_focus()
		attack_menu_focus = false
		$AnimationPlayer.play("attack_disable")
	else:
		menu.get_child(0).grab_focus()
		attack_menu_focus = true
		$AnimationPlayer.play("attack_enable")

func set_player_statistics(hp: Array, mp: Array) -> void:
	var container = $BattlePanel/HBoxContainer/Container/PLayerList/PlayerStatistics/VBoxContainer/
	container.get_node("HPBar").value = hp[0]
	container.get_node("MPBar").value = mp[0]
	container.get_node("HPBar/Label").text = str(hp[0])
	container.get_node("MPBar/Label").text = str(mp[0])
	
	container.get_node("HPBar").max_value = hp[1]
	container.get_node("MPBar").max_value = mp[1]

func message_show() -> void:
	$AnimationPlayer.play("message_show")

func message_hide() -> void:
	$AnimationPlayer.play("message_hide")

func investigation_show() -> void:
	$AnimationPlayer.play("investigation_show")

func investigation_hide() -> void:
	$AnimationPlayer.play("investigation_hide")