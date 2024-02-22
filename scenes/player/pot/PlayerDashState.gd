extends State
class_name PlayerDashState

const MAX_DASH_SPEED = 1500

@export var player: CharacterBody2D
@export var dash_timer: Timer
@export var invincibility_timer: Timer
@export var pot: Node2D
@export var pot_collision: CollisionShape2D
@export var fire_particle: PackedScene

var dash_vector: Vector2
var can_apply_friction = false


func enter() -> void:
	pot.switch_pot_collision(true)
	player.collision_mask = 1
	can_apply_friction = false
	dash_timer.timeout.connect(on_dash_timer_timeout)
	dash_timer.start()
	invincibility_timer.start()
	dash_vector = player.input_vector
	player.velocity = dash_vector * 6000
	player.velocity = player.velocity.limit_length(MAX_DASH_SPEED)
	
	
func exit() -> void:
	dash_timer.timeout.disconnect(on_dash_timer_timeout)
	player.collision_mask = 5
	
func update(delta: float) -> void:
	spawn_fire()
	
func physics_update(delta: float) -> void:
	if can_apply_friction:
		apply_friction(delta)
	player.move_and_slide()
	
	
func apply_friction(delta) -> void:
	if player.velocity.length() > 300:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 1 - exp(-10 * delta))
	else:
		if player.input_vector != Vector2.ZERO:
			transitioned.emit(self, "MoveState")
		else:
			transitioned.emit(self, "IdleState")
	
func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(0.5, 2.0)
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = pot.global_position
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)

func on_dash_timer_timeout():
	can_apply_friction = true
