extends State

@export var animation_player: AnimationPlayer

func enter() -> void:
	animation_player.play("idle")
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
