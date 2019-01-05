extends Control

func set_message(message: String, speaker: String = "") -> void:
	$MessagePanel/ScrollContainer/Message.text = message
	$MessagePanel/Speaker.text = speaker

func set_description(description: String) -> void:
	$InvestigationPanel/ScrollContainer/Description.text = description

func battle_show() -> void:
	$AnimationPlayer.play("battle_show")
	$BattlePanel/HBoxContainer/VBoxContainer/AttackButton.grab_focus()

func battle_hide() -> void:
	$AnimationPlayer.play("battle_hide")

func message_show() -> void:
	$AnimationPlayer.play("message_show")

func message_hide() -> void:
	$AnimationPlayer.play("message_hide")

func investigation_show() -> void:
	$AnimationPlayer.play("investigation_show")

func investigation_hide() -> void:
	$AnimationPlayer.play("investigation_hide")