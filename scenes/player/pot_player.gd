extends CharacterBody2D


const ACCELERATION = 3000
const FRICTION = 3000
const MAX_SPEED = 350

var blend_position: Vector2 = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	move(delta)
	animate()
	
func move(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	elif input_vector != Vector2.ZERO:
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
	if Input.is_action_just_pressed("move_down"):
		animation_player.play("default_down")
	elif Input.is_action_just_pressed("move_up"):
		animation_player.play("default_up")
		
	if Input.is_action_just_pressed("move_right"):
		animation_player.play("default_right")
	elif Input.is_action_just_pressed("move_left"):
		animation_player.play("default_left")
