extends State
class_name PlayerMoveState

const ACCELERATION := 3000
const MAX_SPEED = 450

@export var player: CharacterBody2D

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	move(delta)

func move(delta):
	var input_vector: Vector2
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	apply_movement(input_vector * ACCELERATION * delta, delta)
	player.move_and_slide()

func apply_movement(amount, delta) -> void:
	player.velocity += amount
	if player.velocity.length() > MAX_SPEED:
		player.velocity = lerp(player.velocity, player.velocity.limit_length(MAX_SPEED), 1 - exp(-1 * delta))
	else:
		player.velocity = player.velocity.limit_length(MAX_SPEED)
