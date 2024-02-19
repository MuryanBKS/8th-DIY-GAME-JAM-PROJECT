extends State

@export var animation_tree: AnimationTree

@onready var state_machine = animation_tree["parameters/playback"]


func enter():
	state_machine.travel("died")
