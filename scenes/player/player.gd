class_name Player
extends CharacterBody2D

signal press_dash
signal dash_finished

@export var fire_particle: PackedScene

const ACCELERATION := 3000
const FRICTION = 100
const MAX_SPEED = 450
const MAX_DASH_SPEED = 2500


enum {IDLE, WALK, PUSH_CART}
enum {UP, DOWN, RIGHT, LEFT}

var state = IDLE
var cart_pos: int
var is_pushing_cart = false
var is_dashing = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var blend_position: Vector2 = Vector2.ZERO
var time_scale = 1.0

var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/walk/walk_bs2d/blend_position",
	"parameters/push_cart/push_bs2d/blend_position",
]
var animation_tree_state_keys = [
	"idle",
	"walk",
	"push_cart"
]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("push"):
		is_pushing_cart = !is_pushing_cart
		
	move(delta)
	animate()
	
func move(delta):
	var input_vector: Vector2
	if not is_dashing:
		input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input_vector == Vector2.ZERO:
			state = IDLE
			apply_friction(delta)
			
		elif input_vector != Vector2.ZERO and not is_pushing_cart:
			state = WALK
			apply_movement(input_vector * ACCELERATION * delta)
			blend_position = input_vector
		elif input_vector != Vector2.ZERO and is_pushing_cart:
			state = PUSH_CART
			apply_movement(input_vector * ACCELERATION * delta)
			blend_position = input_vector
			if randf() > 0.95:
				spawn_fire()
			
	if not is_dashing and Input.is_action_just_pressed("dash") and input_vector != Vector2.ZERO:
		is_dashing = true
		press_dash.emit()
		$DashTimer.start()
		dash(input_vector * 3000)
		
	if is_dashing:
		#Engine.time_scale = 0.3
		animation_tree.set("parameters/push_cart/TimeScale/scale", 5.0)
		if randf() > 0.4:
			spawn_fire()
	
	move_and_slide()
	
	
func change_cart_position(direction: int):
	if direction == UP:
		cart_pos = UP
		$Pot.position = %CartUp.position
		$PotCollisionShape2D.position = %CartUp.position + Vector2(0, -18)
	if direction == DOWN:
		cart_pos = DOWN
		$Pot.position = %CartDown.position
		$PotCollisionShape2D.position = %CartDown.position + Vector2(0, 24)
	if direction == RIGHT:
		cart_pos = RIGHT
		$Pot.position = %CartRight.position
		$PotCollisionShape2D.position = %CartRight.position + Vector2(18, 0)
	if direction == LEFT:
		cart_pos = LEFT
		$Pot.position = %CartLeft.position
		$PotCollisionShape2D.position = %CartLeft.position + Vector2(-18, 0)
		
func spawn_fire():
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(0.3, 0.8)
	if is_dashing:
		size = randf_range(0.5, 4.0)
	
	fire_particle_instance.scale = Vector2(size, size)
	
	
	if cart_pos == UP:
		fire_particle_instance.global_position = %CartUp.global_position
	if cart_pos == DOWN:
		fire_particle_instance.global_position = %CartDown.global_position
	if cart_pos == RIGHT:
		fire_particle_instance.global_position = %CartRight.global_position + Vector2(0, 45)
	if cart_pos == LEFT:
		fire_particle_instance.global_position = %CartLeft.global_position + Vector2(0, 45)
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
		
func apply_friction(delta) -> void:
	if velocity.length() > 200:
		#velocity -= velocity.normalized() * amount
		velocity = lerp(velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		velocity = Vector2.ZERO
		
		
func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)
			
			
func dash(amount):
	velocity = amount
	velocity = velocity.limit_length(MAX_DASH_SPEED)
	
func animate() -> void:
	state_machine.travel(animation_tree_state_keys[state])
	animation_tree.set(blend_pos_paths[state], blend_position)


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	#Engine.time_scale = 1.0
	dash_finished.emit()
	animation_tree.set("parameters/push_cart/TimeScale/scale", 1.0)
	
