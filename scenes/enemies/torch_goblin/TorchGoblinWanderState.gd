extends State


const SPEED := 100

@export var animation_player: AnimationPlayer
@export var wander_timer: Timer
@export var animated_sprite_2d: AnimatedSprite2D
@export var health_component: HealthComponent

var random_vector: Vector2


func enter() -> void:
	wander_timer.timeout.connect(on_wander_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	wander_timer.wait_time = randf_range(1.0, 3.0)
	wander_timer.start()
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	randomize_wander()
	
func exit() -> void:
	wander_timer.timeout.disconnect(on_wander_timer_timeout)
	health_component.health_changed.disconnect(on_health_changed)
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	move(delta)

func get_target_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()

func randomize_wander() -> void:
	owner.move_direction = (get_target_direction() + random_vector).normalized()

func move(delta):
	owner.velocity = owner.move_direction * SPEED
	owner.move_and_slide()

func animate():
	animation_player.play("move")
	if owner.move_direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif owner.move_direction.x < 0:
		animated_sprite_2d.flip_h = true
		
		
func on_wander_timer_timeout():
	transitioned.emit(self, "IdleState")
	
	
func on_health_changed():
	transitioned.emit(self, "DiedState")
