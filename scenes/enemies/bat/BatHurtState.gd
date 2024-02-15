extends State
class_name BatHurtState

@export var bat: CharacterBody2D
@export var health_component: HealthComponent
@export var hurt_component: HurtComponent
@export var animation_player: AnimationPlayer
@export var hit_collision: CollisionShape2D

var player: CharacterBody2D
var knockback_direction: Vector2
var random_vector: Vector2


func enter():
	hit_collision.set_deferred("disabled", true)
	player = get_tree().get_first_node_in_group("player")
	random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_player_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_player_direction() + random_vector
	bat.velocity = knockback_direction.normalized() * 1800.0
	animation_player.play("hurt")
	
	
func physics_update(delta: float) -> void:
	knock_back(delta)
		
		
func exit():
	hit_collision.set_deferred("disabled", false)
	
	
func get_player_direction() -> Vector2:
	return (player.global_position - bat.global_position).normalized()
	
	
func knock_back(delta):
	bat.velocity = lerp(bat.velocity, Vector2.ZERO, 1 - exp(-8 * delta))
	if bat.velocity.length() < 30 and animation_player.animation_finished:
		bat.velocity = Vector2.ZERO
		if health_component.get_health() <= 0:
			transitioned.emit(self, "DiedState")
		transitioned.emit(self, "ChaseState")
	bat.move_and_slide()
	
