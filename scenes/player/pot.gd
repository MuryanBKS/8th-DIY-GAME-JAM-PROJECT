class_name Pot
extends Node2D

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.press_dash.connect(on_dash)
	player.dash_finished.connect(on_dash_finished)
	
	
func get_pot_center_position() -> Vector2:
	return %PotCenter.global_position
	
	
func on_dash(input_vector):
	$AnimationPlayer.speed_scale = 5.0
	$PotSprite.speed_scale = 5.0
	
func on_dash_finished():
	$AnimationPlayer.speed_scale = 1.0
	$PotSprite.speed_scale = 1.0
	
