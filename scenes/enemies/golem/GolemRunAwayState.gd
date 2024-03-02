extends State


const SPEED := 200

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer
@export var visuals: Node2D
@export var range_attack_area: Area2D
@export var run_away_timer: Timer


var random_vector: Vector2
var direction_decided = false


func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	run_away_timer.timeout.connect(on_timer_timeout)
	run_away_timer.wait_time = randf_range(0.5, 1.0)
	run_away_timer.start()
	direction_decided = false
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	run_away_timer.timeout.disconnect(on_timer_timeout)
	
func update(delta: float) -> void:
	if not direction_decided:
		if abs(rad_to_deg(random_vector.angle_to(get_player_direction()))) < 90:
			random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		else :
			direction_decided = true
			owner.move_direction = random_vector
	animate()
			
func physics_update(delta: float) -> void:
	if direction_decided:
		move()


func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()


func animate():
	animation_player.play("idle")
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1


func move():
	owner.velocity = owner.move_direction * SPEED
	owner.move_and_slide()


func on_timer_timeout():
	if range_attack_area.get_overlapping_areas().is_empty():
		owner.move_direction = get_player_direction()
		animate()
		transitioned.emit(self, "LaserState")
	else :
		owner.move_direction = get_player_direction()
		animate()
		if randf() > 0.5:
			transitioned.emit(self, "RangeAttackState")
		else:
			transitioned.emit(self, "ChaseState")


func on_health_changed():
	if not owner.get_buff:
		transitioned.emit(self, "HurtState")
