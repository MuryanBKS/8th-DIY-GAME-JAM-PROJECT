extends CharacterBody2D


const SPEED = 300.0

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	move()

func get_player_direction() -> Vector2:
	return (player.global_position - global_position).normalized()

func move():
	velocity = get_player_direction() * SPEED
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Pot:
		queue_free()
