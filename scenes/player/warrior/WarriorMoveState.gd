extends State
class_name WarriorMoveState

const MAX_SPEED = 700

@export var warrior: CharacterBody2D
@export var animation_tree: AnimationTree
@export var health_component: HealthComponent

var blend_pos_path = "parameters/run/run_bs1d/blend_position"
var previous_x_direction: float

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	state_machine.travel("run")
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	warrior.blend_position.x = previous_x_direction
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	move(delta)
	if Input.is_action_just_pressed("dash"):
		transitioned.emit(self, "AttackState")

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
	if warrior.input_vector.x != 0:
		previous_x_direction = warrior.input_vector.x
		
	if warrior.input_vector.y > 0 or warrior.input_vector.y < 0:
		animation_tree.set(blend_pos_path, previous_x_direction)
	else:
		animation_tree.set(blend_pos_path, warrior.blend_position.x)
		

func on_health_changed():
	transitioned.emit(self, "HurtState")
