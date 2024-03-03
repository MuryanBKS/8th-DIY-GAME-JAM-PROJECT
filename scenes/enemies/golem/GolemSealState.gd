extends State

@export var animation_player: AnimationPlayer
@export var canvas: CanvasLayer

var magic_circle: Area2D

func enter() -> void:
	canvas.hide()
	magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.glow.connect(on_glow)
	animation_player.play("seal")
	owner.switch_lock_health(true)
	
func exit() -> void:
	magic_circle.glow.disconnect(on_glow)
	animation_player.play("RESET")
	owner.switch_lock_health(false)
	canvas.show()
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func on_glow():
	await get_tree().create_timer(2).timeout
	animation_player.play("immune", -1, -1, true)
	await animation_player.animation_finished
	transitioned.emit(self, "ChaseState")
