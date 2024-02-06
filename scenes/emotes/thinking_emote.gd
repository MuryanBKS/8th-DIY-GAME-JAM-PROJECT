class_name ThinkingEmote
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func change_emote(path: String, rect2: Rect2):
	sprite_2d.texture = load(path)
	sprite_2d.region_rect = rect2
	
func think():
	if animation_player.is_playing():
		animation_player.play("think")
		animation_player.seek(0.5)
	else:
		animation_player.play("think")
	await animation_player.animation_finished
	hide()
	
	
func long_think():
	animation_player.play("long_think")

func is_palying() -> bool:
	return animation_player.is_playing()
