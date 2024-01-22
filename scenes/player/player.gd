extends CharacterBody2D


const ACCELERATION = 3000
const FRICTION = 3000
const MAX_SPEED = 350

enum {IDLE, WALK,}
var state = IDLE
var is_pushing_cart = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var blend_position: Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/walk/walk_bs2d/blend_position",
]
var animation_tree_state_keys = [
	"idle",
	"walk",
]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		is_pushing_cart = !is_pushing_cart
	move(delta)
	animate()
	
func move(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(FRICTION * delta)
	elif input_vector != Vector2.ZERO and not is_pushing_cart:
		state = WALK
		apply_movement(input_vector * ACCELERATION * delta)
		blend_position = input_vector
	move_and_slide()
	
	
	

	
func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO
		
		
func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)
	
	
func animate() -> void:
	state_machine.travel(animation_tree_state_keys[state])
	animation_tree.set(blend_pos_paths[state], blend_position)
