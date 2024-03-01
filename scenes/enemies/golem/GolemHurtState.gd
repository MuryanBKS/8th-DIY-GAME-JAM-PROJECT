extends State


@export var health_component: HealthComponent
@export var hurt_component: HurtComponent
@export var animation_player: AnimationPlayer

var knockback_direction: Vector2
var random_vector: Vector2
var in_half_hp = false

func enter():
	owner.collision_mask = 1
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_target_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_target_direction() + random_vector
	owner.velocity = knockback_direction.normalized() * randi_range(600, 1000)
	hurt_animate()
	
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
		print(health_component.get_health() * 1/2)
		if health_component.get_health() <= 0:
			transitioned.emit(self, "DiedState")
		elif health_component.get_health() <= owner.max_health * 1/2 and not in_half_hp:
			in_half_hp = true
			transitioned.emit(self, "SummonState")
		else:
			if randf() > 0.4:
				transitioned.emit(self, "RunAwayState")
			else :
				transitioned.emit(self, "ChaseState")
			
	owner.move_and_slide()
