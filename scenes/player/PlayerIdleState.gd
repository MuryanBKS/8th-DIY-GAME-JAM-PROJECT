extends State
class_name PlayerIdleState

const FRICTION = 100

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree

var input_vector: Vector2
var blend_pos_path = "parameters/idle/idle_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]

func enter():
	state_machine.travel("idle")
	

func update(delta: float) -> void:
	animate()
	
	
func physics_update(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	apply_friction(delta)
	
	
	
func apply_friction(delta) -> void:
	if player.velocity.length() > 5:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		player.velocity = Vector2.ZERO
	player.move_and_slide()

func animate() -> void:
	animation_tree.set(blend_pos_path, player.blend_position)
