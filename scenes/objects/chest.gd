extends StaticBody2D

@export var is_opened := false
@export var treasure_scene :PackedScene

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var detect_enemy_area_2d: Area2D = $DetectEnemyArea2D
@onready var shadow_sprite_2d: Sprite2D = %ShadowSprite2D
@onready var chest_sprite_2d: Sprite2D = %ChestSprite2D

var treasure_scene_instance: Area2D

func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	if is_opened:
		chest_sprite_2d.frame = 1
		shadow_sprite_2d.frame = 1
	else :
		chest_sprite_2d.frame = 0
		shadow_sprite_2d.frame = 0
	
	if not is_opened:
		treasure_scene_instance = treasure_scene.instantiate()
		treasure_scene_instance.global_position = %TreasureMarker2D.global_position
		treasure_scene_instance.hide()
		get_tree().get_first_node_in_group("items").add_child(treasure_scene_instance)
		
	
func _process(delta: float) -> void:
	if animation_player.is_playing() and not is_opened:
		treasure_scene_instance.global_position = %TreasureMarker2D.global_position
	
	
func show_treasure():
	treasure_scene_instance.show()
	await animation_player.animation_finished
	treasure_scene_instance.active()
		
		
func on_health_changed():
	if not is_opened:
		if detect_enemy_area_2d.get_overlapping_bodies().is_empty():
			animation_player.play("open")
		else:
			animation_player.play("locked")
