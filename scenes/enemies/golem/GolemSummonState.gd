extends State



@export var animation_player: AnimationPlayer
@export var summon_monster: Array[PackedScene]
@export var summon_timer: Timer
@export var visuals: Node2D

var spawn_point: Marker2D
var count = 10
var speed = 150
var stop_moving = false
var start_summon = false

func enter() -> void:
	spawn_point = get_tree().get_first_node_in_group("spawn_point")
	summon_timer.timeout.connect(on_timer_timeout)
	
	
func exit() -> void:
	summon_timer.timeout.disconnect(on_timer_timeout)
	
func update(delta: float) -> void:
	pass
		
func physics_update(delta: float) -> void:
	if stop_moving:
		return
		
	if (owner.start_point - owner.global_position).length() < 5:
		stop_moving = true
		animation_player.play("glow")
		summon_timer.start()
		
	move(delta)
	animate()

func get_start_point_direction() -> Vector2:
	return (owner.start_point - owner.global_position).normalized()
	

func move(delta):
	owner.move_direction = get_start_point_direction()
	owner.velocity = lerp(owner.velocity, get_start_point_direction() * speed, 1 - exp(-5 * delta))
	owner.move_and_slide()


func animate():
	animation_player.play("idle")
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1

func summon():
	var monster = summon_monster.pick_random().instantiate() as CharacterBody2D
	monster.global_position = spawn_point.global_position
	monster.is_summoned = true
	get_tree().get_first_node_in_group("enemies").add_child(monster)
	count -= 1
	if count <= 0:
		transitioned.emit(self, "IdleState")

func on_timer_timeout():
	animation_player.play("glow")
	summon()
