extends StaticBody2D

@export var is_locked = true : set = set_lock


func set_lock(value):
	%LockSprite.visible = value
	is_locked = value

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if not is_locked:
		%AnimationPlayer.play("open")
	else:
		%AnimationPlayer.play("lock")
		
