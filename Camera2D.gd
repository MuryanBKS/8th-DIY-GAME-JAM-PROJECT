extends Camera2D

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	
	
func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, player.global_position, 1 - exp(-5 * delta))

