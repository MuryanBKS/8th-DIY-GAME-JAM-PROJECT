extends State
class_name PlayerNpcState

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree

var blend_pos_path = "parameters/idle/idle_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	state_machine.travel("idle")
	animation_tree.set(blend_pos_path, player.blend_position)
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
