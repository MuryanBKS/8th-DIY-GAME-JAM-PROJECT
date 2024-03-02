extends CharacterBody2D

@export var buff_timer: Timer

var move_direction: Vector2
var start_point :Vector2
var get_buff = false : set = set_buff
var in_half_hp = false

@onready var health_component: HealthComponent = $HealthComponent
@onready var max_health = health_component.get_health()
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar



func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	buff_timer.timeout.connect(on_timer_timeout)
	health_bar.init_health(health_component.get_health())
	start_point = global_position

func switch_lock_health(value: bool):
	%CollisionShape2D.set_deferred("disabled", value)

func set_buff(value):
	get_buff = value
	if value:
		buff_timer.start()


func on_health_changed():
	health_bar.health = health_component.get_health()


func on_timer_timeout():
	%StateMachine.current_state.transitioned.emit(%StateMachine.current_state, "ArmorBuffState")
