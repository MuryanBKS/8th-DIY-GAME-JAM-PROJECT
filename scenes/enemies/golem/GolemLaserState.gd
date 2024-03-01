extends State

@export var animation_player: AnimationPlayer
@export var laser: Node2D
@export var laser_mark: Marker2D
@export var laser_timer: Timer

var start = false
var direction: int

func enter() -> void:
	laser_timer.timeout.connect(on_timer_timeout)
	start = false
	laser.look_at(GameManager.character_now.global_position)
	direction = decide_rotate_direction()
	laser.rotate(-direction * 0.25)
	animation_player.play("laser")
	await animation_player.animation_finished
	laser.show()
	animation_player.play("laser_start")
	start = true
	laser_timer.start()
	laser.position = Vector2(0, -45)
	
	
func exit() -> void:
		laser_timer.timeout.disconnect(on_timer_timeout)
		animation_player.play("RESET")
	
	
func update(delta: float) -> void:
	if start:
		#animation_player.play("glow")
		var target_position = laser.global_position + get_player_direction() * 10
		laser.rotate(deg_to_rad(direction * 0.15))
		laser.global_position = lerp(laser.global_position, target_position, 0.01)
		
func physics_update(delta: float) -> void:
	pass
	
	
func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - laser.global_position).normalized()
	
	
func decide_rotate_direction() -> int:
	var laser_position = laser_mark.position
	var player_position = laser.to_local(GameManager.character_now.global_position)
	var rotate_direction = sign(rad_to_deg(laser_position.angle_to_point(player_position)))
	return rotate_direction


func on_timer_timeout():
	start = false
	animation_player.play_backwards("laser_start")
	await animation_player.animation_finished
	laser.hide()
	transitioned.emit(self, "IdleState")
