extends Node

signal slow_down
signal slow_down_finished


func _ready() -> void:
	slow_down.connect(on_slow_down)
	slow_down_finished.connect(on_slow_down_finished)

func on_slow_down(scale = 0.1):
	Engine.time_scale = scale
	
func on_slow_down_finished():
	Engine.time_scale = 1.0
