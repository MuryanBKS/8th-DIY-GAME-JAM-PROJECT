extends State
class_name BatChaseState

const SPEED = 200.0


@export var visual: Node2D
@export var bat: CharacterBody2D


var player: CharacterBody2D



func enter():
	visual.rotation = 0
	player = get_tree().get_first_node_in_group("player")
	
	
func physics_update(delta: float) -> void:
	move(delta)
	
	
func get_player_direction() -> Vector2:
	return (player.global_position - bat.global_position).normalized()
	
	
func move(delta):
	if get_player_direction().x > 0:
		%Visual.scale.x = 1
	elif get_player_direction().x < 0:
		%Visual.scale.x = -1
		
	bat.velocity = get_player_direction() * SPEED
	bat.move_and_slide()
