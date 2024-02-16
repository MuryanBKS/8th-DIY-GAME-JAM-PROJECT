extends State
class_name BatDiedState

const SPEED = 800.0

@export var animation_player: AnimationPlayer
@export var bat_collision: CollisionShape2D
@export var bat: CharacterBody2D
@export var hit_collision: CollisionShape2D

var player: CharacterBody2D

func enter():
	hit_collision.set_deferred("disabled", true)
	bat.z_index = 100
	player = get_tree().get_first_node_in_group("player")
	bat_collision.set_deferred("disabled", true)
	animation_player.play("die")


func physics_update(delta: float) -> void:
	absorbed_to_player(delta)
	if (player.get_cart_position() - bat.global_position).length() < 10:
		player.emote_changed.emit("res://scenes/emotes/tile_0120.png", Rect2(0, 0, 16, 16))
		owner.queue_free()
		

func get_player_direction() -> Vector2:
	return (player.get_cart_position() - bat.global_position).normalized()
	
	
func absorbed_to_player(delta):
	if get_player_direction().x > 0:
		%Visual.scale.x = 1
	elif get_player_direction().x < 0:
		%Visual.scale.x = -1
		
	bat.velocity = lerp(bat.velocity, get_player_direction() * SPEED, 1 - exp(-30 * delta))
	bat.move_and_slide()
