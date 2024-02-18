extends GPUParticles2D

func _ready() -> void:
	start()

func start():
	$Timer.wait_time = randf_range(0.4, 0.7)
	$Timer.start()

func _on_timer_timeout() -> void:
	emitting = false
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
