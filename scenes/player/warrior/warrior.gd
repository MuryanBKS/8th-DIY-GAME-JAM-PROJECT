extends CharacterBody2D
class_name Warrior

signal emote_changed(path: String, rect_size: Rect2)

var input_vector: Vector2
var blend_position: Vector2


@onready var health_component: HealthComponent = $HealthComponent
@onready var thinking_emote: ThinkingEmote = $ThinkingEmote
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

func _ready() -> void:
	emote_changed.connect(on_emote_changed)
	health_component.health_changed.connect(on_health_changed)
	
func _physics_process(_delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		blend_position = input_vector

func get_attack_buff(value: int):
	$HitboxComponent.damage += value

func get_hp_buff(value: int):
	health_component.health += value
	health_bar.health = health_component.get_health()

func active_listener():
	%AudioListener2D.current = true


func on_emote_changed(path, rect2):
	%ThinkingEmote.change_emote(path, rect2)
	%ThinkingEmote.think()

func on_health_changed():
	health_bar.health = health_component.get_health()
