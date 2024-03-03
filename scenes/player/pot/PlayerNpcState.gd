extends State
class_name PlayerNpcState

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree
@export var pot: Node2D
@export var canvas: CanvasLayer

var blend_pos_path = "parameters/idle/idle_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	GameManager.game_start.connect(on_game_start)
	state_machine.travel("idle")
	animation_tree.set(blend_pos_path, player.blend_position)
	if owner.is_active:
		pot.become_empty()
		canvas.hide()
	owner.is_active = true
	
func exit() -> void:
	GameManager.game_start.disconnect(on_game_start)
	if owner.is_active:
		canvas.show()
		
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func on_game_start():
	transitioned.emit(self, "IdleState")
