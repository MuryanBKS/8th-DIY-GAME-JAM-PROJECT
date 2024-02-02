extends Node2D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var tween: Tween


func _ready() -> void:
	var player: CharacterBody2D
	player = get_tree().get_first_node_in_group("player")
	player.press_dash.connect(on_press_dash)
	player.dash_finished.connect(on_dash_finished)
	
func on_press_dash():
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.tween_property(world_environment.environment, "adjustment_brightness", 0.7, 0.15).set_trans(Tween.TRANS_EXPO)
	#tween.parallel().tween_property(world_environment.environment, "adjustment_contrast", 1.6, 0.15).set_trans(Tween.TRANS_CUBIC)
	#await tween.finished
	pass

func on_dash_finished():
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.tween_property(world_environment.environment, "adjustment_brightness", 0.7, 0.5).set_trans(Tween.TRANS_EXPO)
	#tween.parallel().tween_property(world_environment.environment, "adjustment_contrast", 1.4, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#await tween.finished
	#tween.kill()
	pass
