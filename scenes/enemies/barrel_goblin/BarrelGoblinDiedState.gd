extends State

@export var animation_player: AnimationPlayer
@export var barrel_collision: CollisionShape2D
@export var hurt_sound: AudioStreamPlayer2D
@export var fire_particle: PackedScene

var knockback_direction: Vector2
var random_vector: Vector2

var is_exploding = false

func enter() -> void:
	if GameManager.character_now.name == "Player":
		spawn_fire()
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_target_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_target_direction() + random_vector
	owner.velocity = knockback_direction.normalized() * randi_range(500, 1000)
	
	GameManager.slow_down.emit()
	await get_tree().create_timer(0.1).timeout
	GameManager.slow_down_finished.emit()
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
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
	hurt_sound.play()
	await get_tree().create_timer(0.8).timeout
	barrel_collision.set_deferred("disabled", true)
	animation_player.play("explode")
	await animation_player.animation_finished
	owner.queue_free()

func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(1.0, 3.0)
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = owner.global_position
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
