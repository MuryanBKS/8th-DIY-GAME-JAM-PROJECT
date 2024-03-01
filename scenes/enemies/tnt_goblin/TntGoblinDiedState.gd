extends State

const SPEED = 800.0

@export var animation_player: AnimationPlayer
@export var goblin_collision: CollisionShape2D

var player: CharacterBody2D

func enter():
	owner.z_index = 100
	player = get_tree().get_first_node_in_group("player")
	goblin_collision.set_deferred("disabled", true)
	animation_player.play("explode")
	

#func physics_update(delta: float) -> void:
	#if GameManager.character_now is Player:
		#absorbed_to_player(delta)
		#if (player.get_cart_position() - owner.global_position).length() < 10:
			#GameManager.enemy_collected.emit("Attack", 10)
			#player.emote_changed.emit("res://scenes/emotes/tile_0120.png", Rect2(0, 0, 16, 16))
			#owner.queue_free()
	#else:
		#await animation_player.animation_finished
		#animation_player.play("fade")
		#await animation_player.animation_finished
		#owner.queue_free()
		#
#
#func get_player_direction() -> Vector2:
	#return (player.get_cart_position() - owner.global_position).normalized()
	#
	#
#func absorbed_to_player(delta):
	#owner.velocity = lerp(owner.velocity, get_player_direction() * SPEED, 1 - exp(-30 * delta))
	#owner.move_and_slide()
