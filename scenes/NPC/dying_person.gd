extends Area2D

var emotes: Array[String] = [
	"res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png",
	"res://scenes/emotes/tile_0114.png"
]

var emote: String
var is_rescued = false

@onready var thinking_emote: ThinkingEmote = %ThinkingEmote


func _ready() -> void:
	thinking_emote.change_emote("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png", Rect2(6*16, 0*16, 16, 16))
	thinking_emote.think()

func _process(delta: float) -> void:
	if thinking_emote.is_palying() or is_rescued:
		return
	emote = emotes.pick_random()
	if emote == emotes[0]:
		thinking_emote.change_emote("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png", Rect2(6*16, 0*16, 16, 16))
		thinking_emote.think()
	else:
		thinking_emote.change_emote("res://scenes/emotes/tile_0114.png", Rect2(0*16, 0*16, 16, 16))
		thinking_emote.think()

func _on_area_entered(area: Area2D) -> void:
	is_rescued = true
	thinking_emote.change_emote("res://scenes/emotes/16x16-Emoji-Pack_v1.1/16x16_emoji_asset_pack_v1.1.png", Rect2(1*16, 2*16, 16, 16))
	thinking_emote.long_think()
