extends StaticBody2D



func _ready() -> void:
	var magic_circle = get_tree().get_first_node_in_group("magic_circle")
	magic_circle.player_entered.connect(on_player_entered)
	
	
func on_player_entered():
	%AnimationPlayer.play("shake")
	await get_tree().create_timer(2).timeout
	%AnimationPlayer.play("glow")
	await await get_tree().create_timer(5).timeout
	%AnimationPlayer.play_backwards("glow")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("show", -1, -1, true)
	await %AnimationPlayer.animation_finished
	$CollisionShape2D.set_deferred("disabled", true)
