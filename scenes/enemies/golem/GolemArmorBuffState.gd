extends State

@export var animation_player: AnimationPlayer


func enter() -> void:
	owner.switch_lock_health(true)
	if owner.get_buff:
		owner.get_buff = false
		animation_player.play_backwards("buff")
	else :
		owner.get_buff = true
		animation_player.play("buff")
	await animation_player.animation_finished
	transitioned.emit(self, "ChaseState")
	

func exit() -> void:
	owner.switch_lock_health(false)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
