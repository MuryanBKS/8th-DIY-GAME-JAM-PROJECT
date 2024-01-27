class_name Pot
extends Area2D

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.press_dash.connect(on_dash)
	
	
func on_dash():
	pass


func _on_timer_timeout() -> void:
		pass
