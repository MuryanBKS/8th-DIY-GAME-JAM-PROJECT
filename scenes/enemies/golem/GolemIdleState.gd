extends State

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	animation_player.play("idle")
	await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
	if randf() > 0.5:
		transitioned.emit(self, "ChaseState")
	else:
		transitioned.emit(self, "RunAwayState")
		
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func on_health_changed():
	if health_component.get_health() <= 0:
		transitioned.emit(self, "DiedState")
	if health_component.get_health() <= owner.max_health * 1/2 and not owner.in_half_hp:
		owner.in_half_hp = true
		transitioned.emit(self, "SummonState")
	if not owner.get_buff:
		transitioned.emit(self, "KnockBackState")
