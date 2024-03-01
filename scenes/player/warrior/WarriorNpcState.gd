extends State
class_name WarriorNpcState


@export var switch_area: Area2D
@export var thinking_emote: Node2D

var emotes: Array[String] = [
	"res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png",
	"res://scenes/emotes/tile_0114.png"
]

var emote: String
var is_rescued = false

func enter() -> void:
	switch_area.body_entered.connect(on_body_entered)
	
func exit() -> void:
	switch_area.body_entered.disconnect(on_body_entered)
	owner.emote_changed.emit("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png",  Rect2(1 * 16, 2 * 16, 16, 16))
	
func update(delta: float) -> void:
	if thinking_emote.is_palying() or is_rescued:
		return
	emote = emotes.pick_random()
	if emote == emotes[0]:
		thinking_emote.change_emote("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png", Rect2(6*16, 0*16, 16, 16))
		thinking_emote.think()
	else:
		thinking_emote.change_emote("res://scenes/emotes/tile_0114.png", Rect2(0*16, 0*16, 16, 16))
		thinking_emote.think()
	
func physics_update(delta: float) -> void:
	pass


func on_body_entered(body: Node2D):
	if body is Player:
		GameManager.player_changed.emit("Warrior")
		transitioned.emit(self, "IdleState")
