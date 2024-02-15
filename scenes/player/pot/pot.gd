class_name Pot
extends Node2D

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	
func get_pot_center_global_position() -> Vector2:
	return %PotCenter.global_position
	
func get_pot_center_position() -> Vector2:
	return %PotCenter.position
	
	
func switch_pot_collision(value: bool):
	%CollisionShape2D.set_deferred("disabled", !value)
