extends CharacterBody2D

signal emote_changed(path: String, rect_size: Rect2)

var input_vector: Vector2
var blend_position := Vector2(0, 0.1)


func _ready() -> void:
	emote_changed.connect(on_emote_changed)


func _physics_process(delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		blend_position = input_vector


func get_cart_position() -> Vector2:
	return $Pot.get_pot_center_position()


func on_emote_changed(path, rect2):
	%ThinkingEmote.change_emote(path, rect2)
	%ThinkingEmote.think()
