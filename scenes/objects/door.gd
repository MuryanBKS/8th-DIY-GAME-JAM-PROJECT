extends StaticBody2D

@export var is_locked = true : set = set_lock


func _ready() -> void:
	%LockSprite.visible = is_locked

func set_lock(value):
	%LockSprite.visible = value
	is_locked = value


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if (is_locked and GameManager.has_key) or not is_locked:
		%AnimationPlayer.play("open")
	else:
		%AnimationPlayer.play("lock")
		
