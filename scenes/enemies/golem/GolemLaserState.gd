extends State

@export var animation_player: AnimationPlayer
@export var laser: Node2D
@export var laser_mark: Marker2D
@export var laser_timer: Timer
@export var health_component: HealthComponent
@export var visuals: Node2D
@export var laser_sound: AudioStreamPlayer2D
@export var laser_sound_stream: AudioStreamOggVorbis
@export var laser_collision: CollisionPolygon2D

var start = false
var direction: int

func enter() -> void:
	start = false
	health_component.health_changed.connect(on_health_changed)
	laser_timer.timeout.connect(on_timer_timeout)
	
	laser.look_at(GameManager.character_now.global_position)
	direction = decide_rotate_direction()
	laser.rotate(-direction * 0.25)
	animation_player.play("laser")
	await animation_player.animation_finished
	laser.show()
	if get_player_direction().x > 0:
		visuals.scale.x = 1
	else:
		visuals.scale.x = -1
		
	animation_player.play("laser_start")
	laser_sound.stream = laser_sound_stream
	laser_sound.play()
	start = true
	laser_timer.start()
	laser.position = Vector2(0, -45)
	laser.global_position += get_player_direction() * 50
	
	owner.switch_lock_health(false)
	
	
func exit() -> void:
		health_component.health_changed.disconnect(on_health_changed)
		laser_timer.timeout.disconnect(on_timer_timeout)
		laser_collision.set_deferred("disabled", true)
		laser.hide()
	
func update(delta: float) -> void:
	if start:
		laser.rotate(deg_to_rad(direction * 0.15))
		
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
	laser_sound.play()
	await animation_player.animation_finished
	laser.hide()
	if health_component.get_health() <= owner.max_health * 1/2 and not owner.in_half_hp:
		owner.in_half_hp = true
		transitioned.emit(self, "SummonState")
	else :
		transitioned.emit(self, "IdleState")


func on_health_changed():
	if health_component.get_health() <= 0:
		transitioned.emit(self, "DiedState")
