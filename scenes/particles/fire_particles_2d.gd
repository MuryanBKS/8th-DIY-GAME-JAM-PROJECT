extends GPUParticles2D

func _ready() -> void:
	start()

func start():
	$Timer.wait_time = randf_range(0.2, 0.5)
	$Timer.start()

func _on_timer_timeout() -> void:
	emitting = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
