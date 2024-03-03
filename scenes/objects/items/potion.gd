extends Area2D

var is_active = false
var hp_buff = 30

func _on_body_entered(body: Node2D) -> void:
	if is_active:
		$CollisionShape2D.set_deferred("disabled", true)
		body.get_hp_buff(hp_buff)
		%AudioStreamPlayer2D.play()
		%Visuals.hide()
		await %AudioStreamPlayer2D.finished
		queue_free()

func active():
	is_active = true
	$CollisionShape2D.set_deferred("disabled", false)
