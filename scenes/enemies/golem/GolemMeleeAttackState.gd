extends State


@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var hit_area: Area2D
@export var detect_attack_area: Area2D
@export var melee: Node2D
@export var visuals: Node2D

var attack_finished = false

func enter() -> void:
	hit_area.set_deferred("monitorable", true)
	health_component.health_changed.connect(on_health_changed)
	attack_finished = false
	attack_animate()
	attack()
	
	
func exit() -> void:
	owner.velocity = Vector2.ZERO
	health_component.health_changed.disconnect(on_health_changed)
	
	
func update(delta: float) -> void:
	pass
	
	
func physics_update(_delta: float) -> void:
	if !attack_finished:
		return
	#if detect_attack_area.get_overlapping_areas().is_empty():
		#transitioned.emit(self, "ChaseState")
	#else :
		#attack_animate()
		#attack()
	
	
func attack_animate():
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1
	animation_player.play("melee")
	await animation_player.animation_finished
	attack_finished = true
	transitioned.emit(self, "RunAwayState")


func attack():
	if owner.move_direction.x > 0:
		melee.scale.x = 1
	elif owner.move_direction.x < 0:
		melee.scale.x = -1

func on_health_changed():
	transitioned.emit(self, "HurtState")
