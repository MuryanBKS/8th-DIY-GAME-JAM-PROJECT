class_name Pot
extends Area2D

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.press_dash.connect(on_dash)
	player.dash_finished.connect(on_dash_finished)
	
	
func on_dash(input_vector):
	$AnimationPlayer.speed_scale = 5.0
	$PotSprite.speed_scale = 5.0
	
func on_dash_finished():
	$AnimationPlayer.speed_scale = 1.0
	$PotSprite.speed_scale = 1.0
	

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt()

func _on_area_entered(area: Area2D) -> void:
	if area is TrapTrigger and (get_parent().get_is_dashing() or get_parent().get_is_decelerating()):
		GameManager.slow_down.emit()


func _on_area_exited(area: Area2D) -> void:
	if area is TrapTrigger:
		GameManager.slow_down_finished.emit()
