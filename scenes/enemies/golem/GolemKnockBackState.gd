extends State


@export var health_component: HealthComponent
@export var hurt_component: HurtComponent
@export var animation_player: AnimationPlayer
@export var fire_particle: PackedScene

var knockback_direction: Vector2
var random_vector: Vector2

func enter():
	if GameManager.character_now.name == "Player":
		spawn_fire()
	owner.collision_mask = 1
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_target_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_target_direction() + random_vector
	owner.velocity = knockback_direction.normalized() * randi_range(600, 1000)
	hurt_animate()
	
	GameManager.slow_down.emit()
	await get_tree().create_timer(0.1).timeout
	GameManager.slow_down_finished.emit()
	
func physics_update(delta: float) -> void:
	knock_back(delta)
		
		
func exit():
	owner.collision_mask = 7
	
func get_target_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()


func hurt_animate():
	animation_player.play("hurt")
	
	
func knock_back(delta):
	owner.velocity = lerp(owner.velocity, Vector2.ZERO, 1 - exp(-8 * delta))
	if owner.velocity.length() < 30:
		owner.velocity = Vector2.ZERO
		change_state()
	owner.move_and_slide()


func change_state():
		if health_component.get_health() <= 0:
			transitioned.emit(self, "DiedState")
		elif health_component.get_health() <= owner.max_health * 1/2 and not owner.in_half_hp:
			owner.in_half_hp = true
			transitioned.emit(self, "SummonState")
		else:
			if owner.in_half_hp:
				if randf() > 0.4:
					transitioned.emit(self, "RunAwayState")
				else :
					transitioned.emit(self, "ArmorBuffState")
			else :
				if randf() > 0.5:
					transitioned.emit(self, "RunAwayState")
				else :
					transitioned.emit(self, "ChaseState")
					
func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(1.0, 3.0)
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = owner.global_position + Vector2(0, -27)
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
