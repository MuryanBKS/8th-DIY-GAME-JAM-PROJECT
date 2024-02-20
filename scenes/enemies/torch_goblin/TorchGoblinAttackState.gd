extends State


@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var hit_area: Area2D
@export var attack_area: Area2D

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
	
	
func physics_update(delta: float) -> void:
	if !attack_finished:
		return
	#if owner.move_direction != Vector2.ZERO:
		#transitioned.emit(self, "ChaseState")
	#else:
		#transitioned.emit(self, "IdleState")
	if attack_area.get_overlapping_areas().is_empty():
		transitioned.emit(self, "ChaseState")
	else :
		attack_animate()
		attack()
	
	
func attack_animate():
	if abs(owner.move_direction.x) >= abs(owner.move_direction.y):
		if owner.move_direction.x > 0:
			animation_player.play("attack_right")
		else :
			animation_player.play("attack_left")
	else :
		if owner.move_direction.y > 0:
			animation_player.play("attack_down")
		else :
			animation_player.play("attack_up")
	await animation_player.animation_finished
	attack_finished = true

func attack():
	if abs(owner.move_direction.x) >= abs(owner.move_direction.y):
		if owner.move_direction.x > 0:
			hit_area.position = Vector2(58, -31)
			hit_area.rotation_degrees = 0
		else :
			hit_area.position = Vector2(-58, -31)
			hit_area.rotation_degrees = 0
	else :
		if owner.move_direction.y > 0:
			hit_area.position = Vector2(0, 11)
			hit_area.rotation_degrees = 90
		else :
			hit_area.position = Vector2(0, -74)
			hit_area.rotation_degrees = 90

func on_health_changed():
	transitioned.emit(self, "HurtState")
