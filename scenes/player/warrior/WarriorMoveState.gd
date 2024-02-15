extends State
class_name WarriorMoveState

const MAX_SPEED = 700

@export var warrior: CharacterBody2D
@export var animation_tree: AnimationTree

var blend_pos_path = "parameters/run/run_bs1d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	state_machine.travel("run")
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	move(delta)

func move(delta):
	if warrior.input_vector == Vector2.ZERO:
		transitioned.emit(self, "IdleState")
	apply_movement(warrior.input_vector * MAX_SPEED, delta)
	warrior.move_and_slide()


func apply_movement(amount, delta) -> void:
	if warrior.velocity.length() < MAX_SPEED:
		warrior.velocity = lerp(warrior.velocity, amount, 1 - exp(-2 * delta))
	else:
		warrior.velocity = warrior.velocity.limit_length(MAX_SPEED)


func animate() -> void:
	animation_tree.set(blend_pos_path, warrior.blend_position.x)
	
