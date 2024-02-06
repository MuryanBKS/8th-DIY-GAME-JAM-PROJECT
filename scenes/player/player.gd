class_name Player
extends CharacterBody2D

signal press_dash
signal dash_finished
signal emote_changed(path: String, rect_size: Rect2)



const ACCELERATION := 3000
const FRICTION = 100
const MAX_SPEED = 450
const MAX_DASH_SPEED = 1500


enum {IDLE, PUSH_CART}
enum {UP, DOWN, RIGHT, LEFT}

var state = IDLE
var cart_pos: int
var is_dashing = false
var is_decelerating = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var fire_particle = preload("res://scenes/particles/fire_particles_2d.tscn")

var blend_position: Vector2 = Vector2.ZERO
var time_scale = 1.0

var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/push_cart/push_bs2d/blend_position",
]
var animation_tree_state_keys = [
	"idle",
	"push_cart"
]

func _ready() -> void:
	emote_changed.connect(on_emote_changed)
	blend_position = Vector2(0, 0.1)
	spawn_fire()

func _physics_process(delta: float) -> void:
	move(delta)
	animate()
	
func move(delta):
	var input_vector: Vector2
	if not is_dashing:
		input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input_vector == Vector2.ZERO:
			state = IDLE
			apply_friction(delta)
		elif input_vector != Vector2.ZERO:
			state = PUSH_CART
			apply_movement(input_vector * ACCELERATION * delta, delta)
			blend_position = input_vector
			
	if not is_dashing and Input.is_action_just_pressed("dash") and input_vector != Vector2.ZERO:
		#emote_changed.emit("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png", Rect2(3*16, 4*16, 16, 16))
		press_dash.emit(input_vector)
		dash(input_vector * 3000)
		
	if is_dashing or is_decelerating:
		spawn_fire()
			
	if Engine.time_scale == 0.1:
		$DashTimer.paused = true
		animation_tree.set("parameters/push_cart/TimeScale/scale", 5.0)
	else:
		$DashTimer.paused = false
		animation_tree.set("parameters/push_cart/TimeScale/scale", 1.0)
	
	move_and_slide()
	
	
func change_cart_position(direction: int):
	if direction == UP:
		cart_pos = UP
		var tween = create_tween()
		tween.tween_property($Pot, "position", %CartUp.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($PotCollisionShape2D, "position", %CartUp.position + Vector2(0, -18), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == DOWN:
		cart_pos = DOWN
		var tween = create_tween()
		tween.tween_property($Pot, "position", %CartDown.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($PotCollisionShape2D, "position", %CartDown.position, 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == RIGHT:
		cart_pos = RIGHT
		var tween = create_tween()
		tween.tween_property($Pot, "position", %CartRight.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($PotCollisionShape2D, "position", %CartRight.position + Vector2(18, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
	if direction == LEFT:
		cart_pos = LEFT
		var tween = create_tween()
		tween.tween_property($Pot, "position", %CartLeft.position, 0.1).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property($PotCollisionShape2D, "position", %CartLeft.position + Vector2(-18, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
		
		
func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var size = randf_range(1.0, 2.0)
	if is_dashing:
		size = randf_range(0.5, 4.0)
	fire_particle_instance.scale = Vector2(size, size)
	if cart_pos == UP:
		fire_particle_instance.global_position = %CartUp.global_position
	if cart_pos == DOWN:
		fire_particle_instance.global_position = %CartDown.global_position
	if cart_pos == RIGHT:
		fire_particle_instance.global_position = %CartRight.global_position
	if cart_pos == LEFT:
		fire_particle_instance.global_position = %CartLeft.global_position
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
		
func apply_friction(delta) -> void:
	if velocity.length() > 50:
		velocity = lerp(velocity, Vector2.ZERO, 1 - exp(-5 * delta))
	else:
		velocity = Vector2.ZERO
		
		
func apply_movement(amount, delta) -> void:
	velocity += amount
	if velocity.length() > MAX_SPEED and is_decelerating:
		velocity = lerp(velocity, velocity.limit_length(MAX_SPEED), 1 - exp(-1 * delta))
	else:
		velocity = velocity.limit_length(MAX_SPEED)
			
			
func dash(amount):
	is_dashing = true
	$DashTimer.start()
	velocity = amount
	velocity = velocity.limit_length(MAX_DASH_SPEED)
	is_decelerating = true
	%DecelerateTimer.start()
	
func animate() -> void:
	state_machine.travel(animation_tree_state_keys[state])
	animation_tree.set(blend_pos_paths[state], blend_position)
	

func get_is_dashing() -> bool:
	return is_dashing
	
func get_is_decelerating() -> bool:
	return is_decelerating


func _on_dash_timer_timeout() -> void:
	is_dashing = false
	dash_finished.emit()
	

func _on_decelerate_timer_timeout() -> void:
	is_decelerating = false


func on_emote_changed(path, rect2):
	%ThinkingEmote.change_emote(path, rect2)
	%ThinkingEmote.think()
