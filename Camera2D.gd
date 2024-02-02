extends Camera2D

const  CAMERA_NORMAL_SPEED = 5.0
const  CAMERA_FAST_SPEED = 30.0

var player: CharacterBody2D
var camera_speed = CAMERA_NORMAL_SPEED
var tween: Tween

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.press_dash.connect(on_press_dash)
	player.dash_finished.connect(on_dash_finished)
	
func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, player.global_position, 1 - exp(-camera_speed * delta))


func zoom_in():
	camera_speed = CAMERA_FAST_SPEED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(4.0, 4.0), 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT_IN)
	
	
func zoom_out():
	camera_speed = CAMERA_NORMAL_SPEED
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1.5, 1.5), 2.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func on_press_dash():
	zoom_in()
	
func on_dash_finished():
	zoom_out()
