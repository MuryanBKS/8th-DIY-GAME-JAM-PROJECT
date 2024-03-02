extends State
class_name PlayerHurtState

@export var player: CharacterBody2D
@export var health_component: HealthComponent
@export var animation_tree: AnimationTree
@export var pot: Node2D
@export var dash_cooldown_timer: Timer

var blend_pos_path = "parameters/hurt/blend_position"
var hurt_finished = false

@onready var state_machine = animation_tree["parameters/playback"]


func enter():
	dash_cooldown_timer.timeout.connect(on_dash_cooldown_timer_timeout)
	hurt_finished = false
	pot.switch_pot_collision(false)
	hurt()
	
	
func physics_update(_delta: float) -> void:
	if !hurt_finished:
		return
	if player.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	else:
		transitioned.emit(self, "IdleState")
		
		
func exit():
	dash_cooldown_timer.timeout.disconnect(on_dash_cooldown_timer_timeout)
	pot.switch_pot_collision(true)
	
func hurt():
	state_machine.travel("hurt")
	animation_tree.set("parameters/hurt/blend_position", Vector2(0, 1))
	await animation_tree.animation_finished
	if health_component.get_health() <= 0:
		transitioned.emit(self, "DiedState")
	hurt_finished = true


func on_dash_cooldown_timer_timeout():
	pot.show_pot_fire()
	pot.burn()
