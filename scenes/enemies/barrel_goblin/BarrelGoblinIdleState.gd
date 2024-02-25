extends State

@export var animation_player: AnimationPlayer
@export var animated_sprite_2d: AnimatedSprite2D
@export var idle_timer: Timer
@export var health_component: HealthComponent
@export var detect_area: Area2D

var is_active = false

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	idle_timer.timeout.connect(on_idle_timer_timeout)
	detect_area.body_entered.connect(on_body_entered)
	hide_self_animate()
	if not is_active:
		idle_timer.wait_time = randf_range(300,600)
	else :
		idle_timer.wait_time = randf_range(3.0, 5.0)
	idle_timer.start()
	
func exit() -> void:
	idle_timer.timeout.disconnect(on_idle_timer_timeout)
	health_component.health_changed.disconnect(on_health_changed)
	detect_area.body_entered.disconnect(on_body_entered)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func hide_self_animate():
	if owner.move_direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif owner.move_direction.x < 0:
		animated_sprite_2d.flip_h = true
	animation_player.play("hide")
	await animation_player.animation_finished
	animation_player.queue("idle")

func on_idle_timer_timeout():
	transitioned.emit(self, "WanderState")

func on_health_changed():
	transitioned.emit(self, "DiedState")

func on_body_entered(body: Node2D):
	is_active = true
	idle_timer.wait_time = randf_range(1.0, 3.0)
	idle_timer.start()
