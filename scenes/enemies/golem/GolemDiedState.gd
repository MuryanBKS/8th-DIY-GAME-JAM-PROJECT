extends State

@export var animation_player: AnimationPlayer
@export var death_shadow: Sprite2D
@export var default_shadow: Sprite2D

func enter() -> void:
	default_shadow.hide()
	animation_player.play("died")
	death_shadow.show()
	await animation_player.animation_finished
	GameManager.game_clear.emit()
	
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
