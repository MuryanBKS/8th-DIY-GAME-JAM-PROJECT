extends State
class_name BatChaseState

const SPEED = 200.0


@export var bat: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent


var can_move = false
var is_active = false


func enter():
	health_component.health_changed.connect(on_health_changed)
	if not is_active:
		animation_player.play("die", -1, -2.0, true)
		await animation_player.animation_finished
	can_move = true
	animation_player.play("fly", -1, 2.0)
	await get_tree().create_timer(0.5).timeout
	is_active = true
	
	
func physics_update(delta: float) -> void:
	if not can_move:
		return
	move(delta)
	
	
func exit():
	bat.velocity = Vector2.ZERO
	health_component.health_changed.disconnect(on_health_changed)
	
	
func get_player_direction() -> Vector2:
	return (bat.target.global_position - bat.global_position).normalized()
	
	
func move(delta):
	if get_player_direction().x > 0:
		%Visual.scale.x = 1
	elif get_player_direction().x < 0:
		%Visual.scale.x = -1
		
	bat.velocity = lerp(bat.velocity, get_player_direction() * SPEED, 1 - exp(-5 * delta))
	bat.move_and_slide()


func on_health_changed():
	is_active = true
	transitioned.emit(self, "HurtState")
