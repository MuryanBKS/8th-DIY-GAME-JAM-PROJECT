extends State

@export var animation_player: AnimationPlayer
@export var sprite_2d: AnimatedSprite2D
@export var idle_timer: Timer
@export var chase_area: Area2D
@export var player_ray_cast: RayCast2D


func enter() -> void:
	idle_timer.timeout.connect(on_idle_timer_timeout)
	chase_area.body_entered.connect(on_body_entered)
	
	animation_player.play("idle")
	idle_timer.wait_time = randf_range(0.5, 2.0)
	idle_timer.start()
	
	
func exit() -> void:
	idle_timer.timeout.disconnect(on_idle_timer_timeout)
	chase_area.body_entered.disconnect(on_body_entered)
	
	
func update(delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	player_ray_cast.target_position = get_target_direction() * 300
	if chase_area.get_overlapping_bodies().is_empty() or player_ray_cast.get_collider():
		return
	else:
		transitioned.emit(self, "ChaseState")


func get_target_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()


func on_idle_timer_timeout():
	transitioned.emit(self, "WanderState")


func on_body_entered(_body: Node2D):
	if player_ray_cast.get_collider():
		return
	transitioned.emit(self, "ChaseState")
