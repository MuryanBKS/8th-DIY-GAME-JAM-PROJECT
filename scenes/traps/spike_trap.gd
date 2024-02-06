extends Area2D

func trigger_trap():
	$AnimatedSprite2D.play("default")


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("hurt")
