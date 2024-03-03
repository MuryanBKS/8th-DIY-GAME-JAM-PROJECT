extends Area2D

var is_active = false


func _on_body_entered(body: Node2D) -> void:
	if is_active:
		$CollisionShape2D.set_deferred("disabled", true)
		GameManager.get_key.emit()
		%Visuals.hide()
		%AudioStreamPlayer2D.play()
		await %AudioStreamPlayer2D.finished
		queue_free()

func active():
	is_active = true
	$CollisionShape2D.set_deferred("disabled", false)
