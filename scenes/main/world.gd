extends Node2D


func _ready() -> void:
	var magic_circle: Area2D
	magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.glow.connect(on_glow)


func on_glow():
	$BgmAudio.stream = preload("res://assets/sfx/PerituneMaterial_EpicBattle2_loop.ogg")
	$BgmAudio.play()
