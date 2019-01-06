extends Control

func set_message(message: String, speaker: String = "") -> void:
	$MessagePanel/ScrollContainer/Message.text = message
	$MessagePanel/Speaker.text = speaker

func set_description(description: String) -> void:
	$InvestigationPanel/ScrollContainer/Description.text = description

func battle_show() -> void:
	$AnimationPlayer.play("battle_show")
	$BattlePanel/HBoxContainer/Menu/AttackButton.grab_focus()

func battle_hide() -> void:
	$AnimationPlayer.play("battle_hide")

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