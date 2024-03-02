extends State


const DEFAULT_SPEED = 200.0
const DASH_SPEED = 700.0

@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var hit_area: Area2D
@export var detect_attack_area: Area2D
@export var melee: Node2D
@export var visuals: Node2D

var stop_moving = false
var speed = DASH_SPEED

func enter() -> void:
	hit_area.set_deferred("monitorable", true)
	health_component.health_changed.connect(on_health_changed)
	#detect_attack_area.area_entered.connect(on_area_entered)
	stop_moving = false
	owner.switch_lock_health(false)
	
func exit() -> void:
	owner.velocity = Vector2.ZERO
	health_component.health_changed.disconnect(on_health_changed)
	#detect_attack_area.area_entered.disconnect(on_area_entered)
	
	
func update(delta: float) -> void:
	pass
	
	
func physics_update(_delta: float) -> void:
	if not stop_moving and (GameManager.character_now.global_position - owner.global_position).length() > 60:
		move(_delta)
	else:
		stop_moving = true
		attack_animate()
		attack()
	
func attack_animate():
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1
	animation_player.play("melee")
	await animation_player.animation_finished
	if detect_attack_area.get_overlapping_areas().is_empty():
		if randf() > 0.5:
			transitioned.emit(self, "RunAwayState")
		else :
			transitioned.emit(self, "ChaseState")
	else:
		if randf() > 0.7:
			transitioned.emit(self, "MeleeAttackState")
		else:
			transitioned.emit(self, "RangeAttackState")
			


func attack():
	if owner.move_direction.x > 0:
		melee.scale.x = 1
	elif owner.move_direction.x < 0:
		melee.scale.x = -1

func move(delta):
	owner.move_direction = get_player_direction()
	owner.velocity = lerp(owner.velocity, get_player_direction() * speed, 1 - exp(-5 * delta))
	if owner.move_direction.x > 0:
		melee.scale.x = 1
	elif owner.move_direction.x < 0:
		melee.scale.x = -1
	owner.move_and_slide()


func get_player_direction() -> Vector2:
	return (GameManager.character_now.global_position - owner.global_position).normalized()
	

func on_health_changed():
	if health_component.get_health() <= 0:
		transitioned.emit(self, "DiedState")
	if health_component.get_health() <= owner.max_health * 1/2 and not owner.in_half_hp:
		owner.in_half_hp = true
		transitioned.emit(self, "SummonState")


#
#func on_area_entered(_area: Area2D):
	#attack_animate()
	#attack()
	
		#if owner.in_half_hp:
			#if randf() > 0.4:
				#transitioned.emit(self, "RunAwayState")
			#else :
				#transitioned.emit(self, "ArmorBuffState")
		#else :
			#if randf() > 0.1:
				#transitioned.emit(self, "RunAwayState")
			#else :
				#transitioned.emit(self, "ChaseState")
