extends State

@export var animation_player: AnimationPlayer
@export var sprite_2d: AnimatedSprite2D
@export var idle_timer: Timer
@export var chase_area: Area2D
@export var hit_area: Area2D
@export var player_ray_cast: RayCast2D

func enter() -> void:
	idle_timer.timeout.connect(on_idle_timer_timeout)
	chase_area.body_entered.connect(on_body_entered)
	hit_area.set_deferred("monitorable", false)
	if owner.move_direction.x > 0:
		sprite_2d.flip_h = false
	elif owner.move_direction.x < 0:
		sprite_2d.flip_h = true
	animation_player.play("idle")
	idle_timer.wait_time = randf_range(0.5, 2.0)
	idle_timer.start()
	
	
func exit() -> void:
	idle_timer.timeout.disconnect(on_idle_timer_timeout)
	chase_area.body_entered.disconnect(on_body_entered)
	
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	player_ray_cast.target_position = owner.move_direction * 300

func on_idle_timer_timeout():
	transitioned.emit(self, "WanderState")


func on_body_entered(body: Node2D):
	player_ray_cast.target_position = owner.move_direction * 300
	if player_ray_cast.get_collider():
		return
	transitioned.emit(self, "ChaseState")
