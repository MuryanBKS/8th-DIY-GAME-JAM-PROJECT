extends Area2D

signal glow


func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	glow.emit()
	await get_tree().create_timer(2).timeout
	%AnimationPlayer.play("glow")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play_backwards("glow")
	
func start_glow():
	%AnimationPlayer.play("glow")
	
	
func finish_glow():
	%AnimationPlayer.play_backwards("glow")
	
