extends State


@export var health_component: HealthComponent
@export var animation_tree: AnimationTree

var blend_pos_path = "parameters/hurt/hurt_bs2d/blend_position"
var hurt_finished = false

@onready var state_machine = animation_tree["parameters/playback"]


func enter():
	print("hello")
	hurt_finished = false
	hurt()
	
	
func physics_update(delta: float) -> void:
	if !hurt_finished:
		return
	if owner.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	else:
		transitioned.emit(self, "IdleState")
		
		
func exit():
	pass
	
	
func hurt():
	state_machine.travel("hurt")
	animation_tree.set("parameters/hurt/blend_position", Vector2(0, 1))
	await animation_tree.animation_finished
	hurt_finished = true
