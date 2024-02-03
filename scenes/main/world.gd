extends Node2D

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var tween: Tween


func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	var player: CharacterBody2D
	player = get_tree().get_first_node_in_group("player")

