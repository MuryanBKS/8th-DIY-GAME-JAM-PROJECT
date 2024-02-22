class_name Pot
extends Node2D


func get_pot_center_global_position() -> Vector2:
	return %PotCenter.global_position
	
	
func get_pot_center_position() -> Vector2:
	return %PotCenter.position
	
	
func switch_pot_collision(value: bool):
	%CollisionShape2D.set_deferred("disabled", !value)

func become_empty():
	$PotSprite.play("empty")

func hide_pot_fire():
	%AnimationPlayer.play("hide_fire")
	
func show_pot_fire():
	%AnimationPlayer.play("show_fire")

func burn():
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("burn")
