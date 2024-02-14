extends State
class_name PlayerMoveState

const MAX_SPEED = 1000

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree
@export var pot: Node2D
@export var pot_collision: CollisionShape2D

enum {UP, DOWN, RIGHT, LEFT}

var blend_position: Vector2 = Vector2.ZERO
var blend_pos_path = "parameters/push_cart/push_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]


func enter() -> void:
	state_machine.travel("push_cart")

func exit() -> void:
	pass
	
func update(delta: float) -> void:
	animate()
	
func physics_update(delta: float) -> void:
	move(delta)


func move(delta):
	if player.input_vector == Vector2.ZERO:
		transitioned.emit(self, "IdleState")
	apply_movement(player.input_vector * MAX_SPEED, delta)
	player.move_and_slide()


func apply_movement(amount, delta) -> void:
	if player.velocity.length() < MAX_SPEED:
		player.velocity = lerp(player.velocity, amount, 1 - exp(-2 * delta))
	else:
		player.velocity = player.velocity.limit_length(MAX_SPEED)


func change_cart_position(direction: int):
	if direction == UP:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartUp.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartUp.position + Vector2(0, -18), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == DOWN:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartDown.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartDown.position, 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == RIGHT:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartRight.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartRight.position + Vector2(18, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == LEFT:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartLeft.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartLeft.position + Vector2(-18, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
		
func animate() -> void:
	animation_tree.set(blend_pos_path, player.blend_position)
