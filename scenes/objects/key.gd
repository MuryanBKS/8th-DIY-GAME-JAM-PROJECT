extends Area2D

var is_active = false


func _on_body_entered(body: Node2D) -> void:
	if is_active:
		GameManager.get_key.emit()
		queue_free()

func active():
	is_active = true
	$CollisionShape2D.set_deferred("disabled", false)
