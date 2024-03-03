extends State
class_name PlayerDiedState

@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@export var pot: Node2D

@onready var state_machine = animation_tree["parameters/playback"]

func enter():
		state_machine.travel("died")
		pot.switch_pot_collision(false)
		GameManager.player_died.emit()
