extends State
class_name WarriorAttackState

@export var warrior: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree

var blend_pos_paths = [
	"parameters/attack_01/attack_01_bs2d/blend_position",
	"parameters/attack_01/attack_02_bs2d/blend_position"
]

var second_attack = true

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	attack_animate()
	
func physics_update(delta: float) -> void:
	pass

func attack_animate():
	second_attack = !second_attack
	state_machine.travel("attack_01")
	animation_tree.set(blend_pos_paths[0], warrior.blend_position)
