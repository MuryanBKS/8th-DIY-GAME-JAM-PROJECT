extends State

@export var animation_player: AnimationPlayer
@export var barrel_collision: CollisionShape2D
@export var explosion_area: CollisionShape2D

var knockback_direction: Vector2
var random_vector: Vector2

var is_exploding = false

func enter() -> void:
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_target_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_target_direction() + random_vector
	owner.velocity = knockback_direction.normalized() * 1000.0
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	if is_exploding:
		return
	explode_animate()
	
func physics_update(delta: float) -> void:
	knock_back(delta)

func get_target_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()

func knock_back(delta):
	owner.velocity = lerp(owner.velocity, Vector2.ZERO, 1 - exp(-8 * delta))
	if owner.velocity.length() < 30:
		owner.velocity = Vector2.ZERO
	owner.move_and_slide()
	
	
func explode_animate():
	is_exploding = true
	animation_player.play("count_down")
	await get_tree().create_timer(2).timeout
	barrel_collision.set_deferred("disabled", true)
	animation_player.play("explode")
	explosion_area.set_deferred("disabled", false)
	await animation_player.animation_finished
	owner.queue_free()

