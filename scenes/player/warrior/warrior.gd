extends CharacterBody2D
class_name Warrior

var input_vector: Vector2
var blend_position: Vector2


func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		blend_position = input_vector
