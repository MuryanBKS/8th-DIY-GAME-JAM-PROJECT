extends Area2D

var move_direction: Vector2
var detect_player = false
var start_chase := false
var speed = 300
var hit_target = false

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	move_direction = get_player_direction()
	hitbox_component.area_entered.connect(on_hit_area_entered)
	health_component.health_changed.connect(on_health_changed)
	
	
func _physics_process(delta: float) -> void:
	if hit_target:
		return
	if detect_player:
		move_direction = get_player_direction()
		look_at(GameManager.character_now.global_position)
		global_position = lerp(global_position, global_position + 80 * move_direction, 1 - exp(-4 * delta))
		if $ChaseTimer.time_left < 1.0:
			detect_player = false
			speed = 550
	else :
		look_at(global_position + 150 * move_direction)
		global_position += speed * move_direction * delta

func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - global_position).normalized()


func _on_area_entered(area: Area2D) -> void:
	if not hitbox_component.get_overlapping_areas().is_empty():
		$AnimationPlayer.play("explode")
		
	detect_player = true
	$AnimationPlayer.play("glow")
	if not start_chase:
		start_chase = true
		$ChaseTimer.start()

func _on_chase_timer_timeout() -> void:
	detect_player = false


func on_hit_area_entered(_area: Area2D):
	hit_target = true
	$AnimationPlayer.play("explode")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_health_changed():
	hit_target = true
	$AnimationPlayer.play("explode")
