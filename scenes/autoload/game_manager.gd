extends Node

signal slow_down()
signal slow_down_finished

signal enemy_collected(bonus_type: String, bonus_value: int)
signal player_changed(next_character: String)
signal get_key

var character_now: CharacterBody2D
var has_key = false

@onready var pot_status = preload("res://scenes/resources/pot_status_now.tres")

func _ready() -> void:
	slow_down.connect(on_slow_down)
	slow_down_finished.connect(on_slow_down_finished)
	enemy_collected.connect(on_enemy_collected)
	player_changed.connect(on_player_changed)
	get_key.connect(on_get_key)
	character_now = get_tree().get_first_node_in_group("player")
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	
	
func on_slow_down(scale = 0.1):
	Engine.time_scale = scale
	
func on_slow_down_finished():
	Engine.time_scale = 1.0


func on_enemy_collected(bonus_type: String, bonus_value: int):
	pot_status.get_bonus(bonus_type, bonus_value)
	print(pot_status.bonus_types["Attack"])


func on_player_changed(next_character: String):
	var characters = get_tree().get_nodes_in_group("characters")
	for character in characters:
		if next_character == character.name:
			character_now = character
			character.get_buff(pot_status.bonus_types["Attack"])

func on_get_key():
	has_key = true
