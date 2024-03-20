extends CharacterBody2D
class_name Player

signal emote_changed(path: String, rect_size: Rect2)

@export var fire_particle: PackedScene
@export var explode_particle: PackedScene

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
	spawn_fire()
	
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

func spawn_fire():
	randomize()
	var fire_particle_instance = fire_particle.instantiate()
	var explode_particle_instance = explode_particle.instantiate()
	
	var size = 0.01
	fire_particle_instance.scale = Vector2(size, size)
	fire_particle_instance.global_position = global_position
	explode_particle_instance.scale = Vector2(size, size)
	explode_particle_instance.global_position = global_position
	get_tree().get_first_node_in_group("fire").add_child(fire_particle_instance)
	get_tree().get_first_node_in_group("fire").add_child(explode_particle_instance)


func on_emote_changed(path, rect2):
	%ThinkingEmote.change_emote(path, rect2)
	%ThinkingEmote.think()

func on_player_changed(_value):
	%StateMachine.current_state.transitioned.emit(%StateMachine.current_state, "NpcState")


func on_health_changed():
	health_bar.health = health_component.get_health()
