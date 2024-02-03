extends Node2D

@export var enemy_scene: PackedScene


func spawn_enemy():
	var enemy_scene_instance = enemy_scene.instantiate()
	enemy_scene_instance.global_position = global_position
	get_tree().root.add_child(enemy_scene_instance)

func _on_timer_timeout() -> void:
	spawn_enemy()
