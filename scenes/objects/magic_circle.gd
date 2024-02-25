extends Area2D

signal glow


func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	%AnimationPlayer.play("glow")
	glow.emit()
