extends CharacterBody2D
class_name Player

signal emote_changed(path: String, rect_size: Rect2)

var input_vector: Vector2
var blend_position := Vector2(0, 0.1)
var is_active = false

@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar

func _ready() -> void:
	emote_changed.connect(on_emote_changed)
	GameManager.player_changed.connect(on_player_changed)
	health_component.health_changed.connect(on_health_changed)
	health_bar.init_health(health_component.get_health())
	
func _physics_process(_delta: float) -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		blend_position = input_vector
		
		
func get_cart_position() -> Vector2:
	return $Pot.get_pot_center_global_position()

func get_hp_buff(value: int):
	health_component.health += value
	health_bar.health = health_component.get_health()
	
func active_listener():
	%AudioListener2D.current = true



func on_emote_changed(path, rect2):
	%ThinkingEmote.change_emote(path, rect2)
	%ThinkingEmote.think()

func on_player_changed(_value):
	%StateMachine.current_state.transitioned.emit(%StateMachine.current_state, "NpcState")


func on_health_changed():
	health_bar.health = health_component.get_health()
