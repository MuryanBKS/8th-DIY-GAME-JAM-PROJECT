extends StaticBody2D



func _ready() -> void:
	var magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.glow.connect(on_glow)
	
	
func on_glow():
	%AnimationPlayer.play("shake")
	await get_tree().create_timer(2).timeout
	%AnimationPlayer.play("glow")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play_backwards("glow")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("show", -1, -1, true)
	await %AnimationPlayer.animation_finished
	$CollisionShape2D.set_deferred("disabled", true)
