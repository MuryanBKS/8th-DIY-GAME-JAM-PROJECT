extends Area2D

signal glow
signal player_entered

func _on_body_entered(body: Node2D) -> void:
	set_deferred("monitoring", false)
	player_entered.emit()
	await get_tree().create_timer(2).timeout
	%AnimationPlayer.play("glow")
	glow.emit()
	
func start_glow():
	%AnimationPlayer.play("glow")
	
	
func finish_glow():
	%AnimationPlayer.play_backwards("glow")
	
