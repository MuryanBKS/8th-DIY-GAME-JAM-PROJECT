class_name enemy
extends CharacterBody2D

const SPEED = 200.0

@export var fire_particle: PackedScene

var player: CharacterBody2D
var knockback_velocity: Vector2
var knockback_direction: Vector2
var is_hurt = false
var is_died = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	
func _physics_process(delta: float) -> void:
	move(delta)

func get_player_direction() -> Vector2:
	return (player.global_position - global_position).normalized()
	
	
func move(delta):
	if get_player_direction().x > 0:
		%Visual.scale.x = 1
	elif get_player_direction().x < 0:
		%Visual.scale.x = -1
		
	if is_hurt:
		velocity = lerp(velocity, knockback_direction.normalized() * 4000.0, 1 - exp(-8 * delta))
	elif is_died :
		velocity = lerp(velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		velocity = get_player_direction() * SPEED
	move_and_slide()

func hurt():
	%AudioStreamPlayer2D.play()
	$CollisionShape2D.set_deferred("disabled", true)
	%AnimationPlayer.play("hurt")
	var random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if random_vector == get_player_direction():
		randomize()
		random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	knockback_direction = -get_player_direction() + random_vector
	spawn_explosion()
	await %AnimationPlayer.animation_finished
	GameManager.slow_down.emit()
	is_hurt = true
	player.emote_changed.emit("res://scenes/emotes/tile_0120.png", Rect2(0, 0, 16, 16))
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
	%AnimationPlayer.play("die")
