extends State
class_name BatChaseState

const SPEED = 200.0


@export var visual: Node2D
@export var eye_light: Node2D
@export var bat: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent

var player: CharacterBody2D
var can_move = false

func enter():
	health_component.health_changed.connect(on_health_changed)
	player = get_tree().get_first_node_in_group("player")
	visual.rotation = 0
	animation_player.play_backwards("die")
	await animation_player.animation_finished
	can_move = true
	animation_player.play("fly")
	await get_tree().create_timer(0.5).timeout
	eye_light.visible = true
	
	
func physics_update(delta: float) -> void:
	if not can_move:
		return
	move(delta)
	
	
func exit():
	pass
	
	
func get_player_direction() -> Vector2:
	return (player.global_position - bat.global_position).normalized()
	
	
func move(delta):
	if get_player_direction().x > 0:
		%Visual.scale.x = 1
	elif get_player_direction().x < 0:
		%Visual.scale.x = -1
		
	bat.velocity = get_player_direction() * SPEED
	bat.move_and_slide()


func on_health_changed():
	transitioned.emit(self, "HurtState")
