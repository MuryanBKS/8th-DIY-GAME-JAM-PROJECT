extends Camera2D

const  CAMERA_NORMAL_SPEED = 5.0
const  CAMERA_FAST_SPEED = 30.0
const CAMERA_DASH_OFFSET = 150

var player: CharacterBody2D
var camera_speed = CAMERA_NORMAL_SPEED
var tween: Tween
var dash_vector: Vector2
var is_dashing = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	#player.press_dash.connect(on_press_dash)
	#player.dash_finished.connect(on_dash_finished)
	GameManager.slow_down.connect(on_slow_down)
	GameManager.slow_down_finished.connect(on_slow_down_finished)
	
func _physics_process(delta: float) -> void:
	if is_dashing:
		global_position = lerp(global_position, player.global_position + dash_vector * CAMERA_DASH_OFFSET, 1 - exp(-camera_speed * delta))
	else :
		dash_vector = lerp(dash_vector, Vector2.ZERO, 1 - exp(-2 * delta))
		global_position = lerp(global_position, player.global_position + dash_vector * CAMERA_DASH_OFFSET, 1 - exp(-camera_speed * delta))
		

func zoom_in():
	camera_speed = CAMERA_FAST_SPEED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(3.5, 3.5), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	
	
func zoom_out():
	camera_speed = CAMERA_NORMAL_SPEED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1.5, 1.5), 2.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func on_slow_down():
	zoom_in()
	
func on_slow_down_finished():
	zoom_out()

#func on_press_dash(input_vector):
	#is_dashing = true
	#dash_vector = input_vector
#
#func on_dash_finished():
	#is_dashing = false
	
