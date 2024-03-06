extends State


@export var health_component: HealthComponent
@export var hurt_component: HurtComponent
@export var animation_player: AnimationPlayer
@export var hit_collision: CollisionShape2D
@export var sprite: AnimatedSprite2D
@export var hurt_sound: AudioStreamPlayer2D
@export var fire_particle: PackedScene

var knockback_direction: Vector2
var random_vector: Vector2


func enter():
	if GameManager.character_now.name == "Player":
		spawn_fire()
	hit_collision.set_deferred("disabled", true)
	owner.collision_mask = 1
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_target_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_target_direction() + random_vector
	owner.velocity = knockback_direction.normalized() * randi_range(800, 1800)
	hurt_animate()
	hurt_sound.play()
	
	GameManager.slow_down.emit()
	await get_tree().create_timer(0.1).timeout
	GameManager.slow_down_finished.emit()
	
func physics_update(delta: float) -> void:
	knock_back(delta)
		
		
func exit():
	hit_collision.set_deferred("disabled", false)
	owner.collision_mask = 7
	sprite.modulate = Color.WHITE
	
func get_target_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()


func hurt_animate():
	if abs(owner.move_direction.x) >= abs(owner.move_direction.y):
		if owner.move_direction.x > 0:
			animation_player.play("hurt_right")
		else :
			animation_player.play("hurt_left")
	else :
		if owner.move_direction.y > 0:
			animation_player.play("hurt_down")
		else :
			animation_player.play("hurt_up")
	
	
func knock_back(delta):
	owner.velocity = lerp(owner.velocity, Vector2.ZERO, 1 - exp(-8 * delta))
	if owner.velocity.length() < 30:
		owner.velocity = Vector2.ZERO
		if health_component.get_health() <= 0:
			transitioned.emit(self, "DiedState")
		transitioned.emit(self, "ChaseState")
	owner.move_and_slide()

func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(1.0, 3.0)
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = owner.global_position + Vector2(0, -27)
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
