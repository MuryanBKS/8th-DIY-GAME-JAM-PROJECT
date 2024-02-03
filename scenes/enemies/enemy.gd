class_name enemy
extends CharacterBody2D

const SPEED = 200.0

@export var fire_particle: PackedScene

var player: CharacterBody2D
var knockback_velocity: Vector2
var is_hurt = false
var is_died = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	move(delta)

func get_player_direction(delta) -> Vector2:
	return (player.global_position - global_position).normalized()
	
	
func move(delta):
	if is_hurt:
		velocity = lerp(velocity, -get_player_direction(delta) * 5000.0, 1 - exp(-8 * delta))
	elif is_died :
		velocity = lerp(velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		velocity = get_player_direction(delta) * SPEED
	move_and_slide()

func hurt():
	$CollisionShape2D.set_deferred("disabled", true)
	spawn_explosion()
	await get_tree().create_timer(0.1).timeout
	is_hurt = true
	GameManager.slow_down.emit()
	$KnockbackTimer.start()
	
func spawn_explosion():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(2.0, 4.0)
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = global_position + Vector2(0, -18) + Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * 10
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
	
func _on_knockback_timer_timeout() -> void:
	GameManager.slow_down_finished.emit()
	is_hurt = false
	is_died = true
	$AnimatedSprite2D.play("died")
	await $AnimatedSprite2D.animation_finished
	queue_free()
