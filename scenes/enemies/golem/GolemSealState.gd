extends State

@export var animation_player: AnimationPlayer

var magic_circle: Area2D

func enter() -> void:
	magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.glow.connect(on_glow)
	animation_player.play("seal")
	
func exit() -> void:
	magic_circle.glow.disconnect(on_glow)
	animation_player.play("RESET")
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func on_glow():
	animation_player.play("immune", -1, -1, true)
	await animation_player.animation_finished
	transitioned.emit(self, "ChaseState")