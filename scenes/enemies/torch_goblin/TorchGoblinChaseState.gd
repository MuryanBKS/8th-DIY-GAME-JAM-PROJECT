extends State


const SPEED = 200.0

@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var animated_sprite_2d: AnimatedSprite2D
@export var chase_area: Area2D


func enter():
	health_component.health_changed.connect(on_health_changed)
	chase_area.body_exited.connect(on_body_exited)
	
	
func physics_update(delta: float) -> void:
	move(delta)
	animate()
	
	
func exit():
	owner.velocity = Vector2.ZERO
	health_component.health_changed.disconnect(on_health_changed)
	chase_area.body_exited.disconnect(on_body_exited)
	
	
func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()
	
	
func move(delta):
	owner.move_direction = get_player_direction()
	owner.velocity = lerp(owner.velocity, get_player_direction() * SPEED, 1 - exp(-5 * delta))
	owner.move_and_slide()


func animate():
	animation_player.play("move")
	if owner.move_direction.x > 0:
		animated_sprite_2d.flip_h = false
	elif owner.move_direction.x < 0:
		animated_sprite_2d.flip_h = true
		
		
func on_health_changed():
	transitioned.emit(self, "HurtState")


func on_body_exited(body: Node2D):
	transitioned.emit(self, "IdleState")
