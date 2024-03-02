extends State


const DEFAULT_SPEED = 200.0
const DASH_SPEED = 700.0

@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var visuals: Node2D
@export var range_chase_area: Area2D
@export var dash_area: Area2D
@export var melee: Node2D
@export var range_attack_cooldown_timer: Timer


var speed := DEFAULT_SPEED


func enter():
	health_component.health_changed.connect(on_health_changed)
	range_chase_area.body_exited.connect(on_body_exited)
	dash_area.body_entered.connect(on_dash_area_body_entered)
	range_attack_cooldown_timer.timeout.connect(on_timer_timeout)
	range_attack_cooldown_timer.wait_time = randf_range(3.0, 5.0)
	range_attack_cooldown_timer.start()
	
	
	
func physics_update(delta: float) -> void:
	move(delta)
	animate()
	
	
func exit():
	speed = DEFAULT_SPEED
	health_component.health_changed.disconnect(on_health_changed)
	range_chase_area.body_exited.disconnect(on_body_exited)
	dash_area.body_entered.disconnect(on_dash_area_body_entered)
	range_attack_cooldown_timer.timeout.disconnect(on_timer_timeout)
	range_attack_cooldown_timer.stop()
	
func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()
	
	
func move(delta):
	owner.move_direction = get_player_direction()
	owner.velocity = lerp(owner.velocity, get_player_direction() * speed, 1 - exp(-5 * delta))
	if owner.move_direction.x > 0:
		melee.scale.x = 1
	elif owner.move_direction.x < 0:
		melee.scale.x = -1
	owner.move_and_slide()


func animate():
	animation_player.play("idle")
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1
		
		
func on_health_changed():
	if health_component.get_health() <= 0:
		transitioned.emit(self, "DiedState")
	if health_component.get_health() <= owner.max_health * 1/2 and not owner.in_half_hp:
		owner.in_half_hp = true
		transitioned.emit(self, "SummonState")
	if not owner.get_buff:
		transitioned.emit(self, "KnockBackState")

func on_timer_timeout():
	if randf() > 0.4:
		transitioned.emit(self, "RangeAttackState")
	else :
		transitioned.emit(self, "IdleState")
		

func on_body_exited(_body: Node2D):
	if randf() < 0.4:
		transitioned.emit(self, "LaserState")
	else :
		transitioned.emit(self, "RangeAttackState")


func on_dash_area_body_entered(_body: Node2D):
	if randf() > 0.4:
		transitioned.emit(self, "MeleeAttackState")
	else:
		transitioned.emit(self, "RunAwayState")
		
