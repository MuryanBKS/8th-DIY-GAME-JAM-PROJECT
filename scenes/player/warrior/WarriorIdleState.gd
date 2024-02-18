extends State

@export var warrior: CharacterBody2D
@export var animation_tree: AnimationTree
@export var health_component: HealthComponent

var blend_pos_path = "parameters/idle/idle_bs1d/blend_position"
var is_active = false

@onready var state_machine = animation_tree["parameters/playback"]

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	state_machine.travel("idle")
	if not is_active:
		var camera = get_tree().get_first_node_in_group("camera")
		camera.player = owner
	is_active = true
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	if warrior.input_vector != Vector2.ZERO:
		transitioned.emit(self, "MoveState")
	apply_friction(delta)
	if Input.is_action_just_pressed("dash"):
		transitioned.emit(self, "AttackState")

func apply_friction(delta) -> void:
	if warrior.velocity.length() > 10:
		warrior.velocity = lerp(warrior.velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		warrior.velocity = Vector2.ZERO
	warrior.move_and_slide()


func animate() -> void:
	animation_tree.set(blend_pos_path, warrior.blend_position.x)


func on_health_changed():
	transitioned.emit(self, "HurtState")
