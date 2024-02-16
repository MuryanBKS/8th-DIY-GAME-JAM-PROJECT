extends State
class_name WarriorAttackState

@export var warrior: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

var blend_pos_paths = [
	"parameters/attack_01/attack_01_bs2d/blend_position",
	"parameters/attack_01/attack_02_bs2d/blend_position"
]

var attack_finished = false

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	attack_finished = false
	attack_animate()
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if !attack_finished:
		return
	if warrior.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	else:
		transitioned.emit(self, "IdleState")

func attack_animate():
	state_machine.travel("attack_01")
	animation_tree.set(blend_pos_paths[0], warrior.blend_position)
	await animation_tree.animation_finished
	attack_finished = true
