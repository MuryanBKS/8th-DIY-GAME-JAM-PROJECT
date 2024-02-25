extends Camera2D

const  CAMERA_NORMAL_SPEED = 2.0
const  CAMERA_SlOW_SPEED = 3.0
const CAMERA_CLOSE_OFFSET = 200
const CAMERA_FAR_OFFSET = 300

@export var player: CharacterBody2D
var camera_speed = CAMERA_NORMAL_SPEED
var tween: Tween
var camera_point: Vector2
var camera_offset: int
var keep_moving = false

func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player")
	#GameManager.slow_down.connect(on_slow_down)
	#GameManager.slow_down_finished.connect(on_slow_down_finished)
	camera_point = player.global_position
	
func _physics_process(delta: float) -> void:
	if !player:
		return
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		if not keep_moving:
			camera_offset = CAMERA_CLOSE_OFFSET
			%Timer.start()
			keep_moving = true
		camera_point = lerp(camera_point, player.global_position + input_vector * camera_offset, 1 - exp(- camera_speed * delta))
	else :
		%Timer.stop()
		camera_point = lerp(camera_point, player.global_position, 1 - exp(-5 * delta))
		if (camera_point - player.global_position).length() < 50:
			keep_moving = false
		
	global_position = lerp(global_position, camera_point, 1 - exp(-3 * delta))
	

func _on_timer_timeout() -> void:
	camera_offset = CAMERA_FAR_OFFSET
	
	
	
#func zoom_in():
	#camera_speed = CAMERA_FAST_SPEED
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.tween_property(self, "zoom", Vector2(3.5, 3.5), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	#
	#
#func zoom_out():
	#camera_speed = CAMERA_NORMAL_SPEED
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.tween_property(self, "zoom", Vector2(1.5, 1.5), 2.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#
#func on_slow_down():
	#zoom_in()
	#
#func on_slow_down_finished():
	#zoom_out()

#func on_press_dash(input_vector):
	#is_dashing = true
	#dash_vector = input_vector
#
#func on_dash_finished():
	#is_dashing = false
	

