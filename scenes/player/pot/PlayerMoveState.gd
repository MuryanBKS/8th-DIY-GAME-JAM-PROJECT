extends State
class_name PlayerMoveState

const MAX_SPEED = 320

@export var player: CharacterBody2D
@export var animation_tree: AnimationTree
@export var pot: Node2D
@export var pot_collision: CollisionShape2D
@export var health_component: HealthComponent
@export var dash_cooldown_timer: Timer

enum {UP, DOWN, RIGHT, LEFT}

var blend_pos_path = "parameters/push_cart/push_bs2d/blend_position"

@onready var state_machine = animation_tree["parameters/playback"]


func enter() -> void:
	state_machine.travel("push_cart")
	health_component.health_changed.connect(on_health_changed)
	dash_cooldown_timer.timeout.connect(on_dash_cooldown_timer_timeout)
	pot.switch_pot_collision(false)
	
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	dash_cooldown_timer.timeout.disconnect(on_dash_cooldown_timer_timeout)
	
	
func update(_delta: float) -> void:
	animate()
	
	
func physics_update(delta: float) -> void:
	move(delta)
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer.is_stopped():
		transitioned.emit(self, "DashState")
		dash_cooldown_timer.start()
		pot.hide_pot_fire()
		pot.burn()

func move(delta):
	if player.input_vector == Vector2.ZERO:
		transitioned.emit(self, "IdleState")
	apply_movement(player.input_vector * MAX_SPEED, delta)
	player.move_and_slide()


func apply_movement(amount, delta) -> void:
	if player.velocity.length() < MAX_SPEED:
		player.velocity = lerp(player.velocity, amount, 1 - exp(-5 * delta))
	else:
		player.velocity = player.velocity.limit_length(MAX_SPEED)


func change_cart_position(direction: int):
	if direction == UP:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartUp.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartUp.position + Vector2(-1, -20), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == DOWN:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartDown.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartDown.position + Vector2(-1, -30), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == RIGHT:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartRight.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartRight.position + Vector2(-1, -29), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == LEFT:
		var tween = create_tween()
		tween.tween_property(pot, "position", %CartLeft.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(pot_collision, "position", %CartLeft.position + Vector2(-1, -29), 0.3).set_trans(Tween.TRANS_CUBIC)
		
		
func animate() -> void:
	animation_tree.set(blend_pos_path, player.blend_position)
	
	
func on_health_changed():
	transitioned.emit(self, "HurtState")

func on_dash_cooldown_timer_timeout():
	pot.show_pot_fire()
	pot.burn()
