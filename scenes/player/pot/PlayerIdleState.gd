extends State
class_name PlayerIdleState

const FRICTION = 100

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree
@export var health_component: HealthComponent
@export var pot: Node2D
@export var dash_cooldown_timer: Timer

var blend_pos_path = "parameters/idle/idle_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]

func enter():
	pot.switch_pot_collision(false)
	state_machine.travel("idle")
	health_component.health_changed.connect(on_health_changed)
	dash_cooldown_timer.timeout.connect(on_dash_cooldown_timer_timeout)
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	if player.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	apply_friction(delta)
	
	
func exit():
	health_component.health_changed.disconnect(on_health_changed)
	dash_cooldown_timer.timeout.disconnect(on_dash_cooldown_timer_timeout)
	
func apply_friction(delta) -> void:
	if player.velocity.length() > 5:
		player.velocity = lerp(player.velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		player.velocity = Vector2.ZERO
	player.move_and_slide()


func animate() -> void:
	animation_tree.set(blend_pos_path, player.blend_position)


func on_health_changed():
	transitioned.emit(self, "HurtState")

func on_dash_cooldown_timer_timeout():
	pot.show_pot_fire()
	pot.burn()
