extends GPUParticles2D

func _ready() -> void:
	$Timer.wait_time = randf_range(0.2, 0.5)
	$Timer.start()

func _on_timer_timeout() -> void:
	emitting = false
