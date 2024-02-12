extends State
class_name PlayerIdleState

const FRICTION = 100

@export var player: CharacterBody2D

var input_vector: Vector2


func enter():
	pass
	
	
	
func physics_update(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	apply_friction(delta)
	
	
	
func apply_friction(delta) -> void:
	if player.velocity.length() > 50:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		player.velocity = Vector2.ZERO
