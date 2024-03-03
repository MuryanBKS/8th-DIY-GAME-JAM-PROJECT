extends VBoxContainer

func _ready() -> void:
	GameManager.player_died.connect(on_player_died)
	GameManager.game_clear.connect(on_game_clear)

func _on_start_button_button_up() -> void:
	GameManager.game_start.emit()
	hide()


func _on_restart_button_button_up() -> void:
	get_tree().reload_current_scene()


func on_player_died():
	$HBoxContainer/MarginContainer.hide()
	show()

func on_game_clear():
	%Label.text = "Thanks for Playing!"
	$HBoxContainer/MarginContainer.hide()
	show()
