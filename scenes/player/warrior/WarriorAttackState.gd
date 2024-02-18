extends State
class_name WarriorAttackState

@export var warrior: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
@export var health_component: HealthComponent

var blend_pos_paths = [
	"parameters/attack_01/attack_01_bs2d/blend_position",
	"parameters/attack_02/attack_02_bs2d/blend_position"
]

var attack_finished = false
var second_attack = false

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	attack_finished = false
	if warrior.blend_position.length() > 1:
		warrior.blend_position.x = 0
		
	if second_attack:
		attack_01_animate()
		second_attack = !second_attack
	else:
		attack_02_animate()
		second_attack = !second_attack
		
	
func exit() -> void:
	warrior.velocity = Vector2.ZERO
	health_component.health_changed.disconnect(on_health_changed)
	
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if !attack_finished:
		return
	if warrior.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	else:
		transitioned.emit(self, "IdleState")

func attack_01_animate():
	state_machine.travel("attack_01")
	animation_tree.set(blend_pos_paths[0], warrior.blend_position)
	await animation_tree.animation_finished
	attack_finished = true


func attack_02_animate():
	state_machine.travel("attack_02")
	animation_tree.set(blend_pos_paths[1], warrior.blend_position)
	await animation_tree.animation_finished
	attack_finished = true


func on_health_changed():
	transitioned.emit(self, "HurtState")
