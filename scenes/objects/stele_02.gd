extends StaticBody2D



func _ready() -> void:
	var magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.glow.connect(on_glow)
	
	
func on_glow():
	%AnimationPlayer.play("glow")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("hide")
