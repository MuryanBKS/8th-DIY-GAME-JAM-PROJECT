extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var pumpkin_head: Sprite2D = $PumpkinHead

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	animate(direction)
	
	
func animate(direction):
	if direction == Vector2.RIGHT:
		pumpkin_head.frame = 0
	elif direction == Vector2.LEFT:
		pumpkin_head.frame = 2
	elif  direction == Vector2.UP:
		pumpkin_head.frame = 1
	else:
		pumpkin_head.frame = 3
