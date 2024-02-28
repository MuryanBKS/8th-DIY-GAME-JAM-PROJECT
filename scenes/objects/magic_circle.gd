extends Area2D

signal glow


func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	%AnimationPlayer.play("glow")
	await %AnimationPlayer.animation_finished
	glow.emit()
	await get_tree().create_timer(2).timeout
	%AnimationPlayer.play_backwards("glow")
	
