extends CharacterBody2D

var move_direction: Vector2
var start_point :Vector2


@onready var health_component: HealthComponent = $HealthComponent
@onready var max_health = health_component.get_health()
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar


func _ready() -> void:
	health_component.health_changed.connect(on_health_changed)
	health_bar.init_health(health_component.get_health())
	start_point = global_position


func on_health_changed():
	health_bar.health = health_component.get_health()
