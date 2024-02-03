class_name enemy
extends CharacterBody2D
const SPEED = 200.0

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
	is_hurt = true
	GameManager.slow_down.emit()
	$KnockbackTimer.start()


func _on_knockback_timer_timeout() -> void:
	GameManager.slow_down_finished.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	is_hurt = false
	is_died = true
	$AnimatedSprite2D.play("died")
	await $AnimatedSprite2D.animation_finished
	queue_free()
