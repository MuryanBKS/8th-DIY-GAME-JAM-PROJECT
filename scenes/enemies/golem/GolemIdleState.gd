extends State

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	animation_player.play("idle")
	await get_tree().create_timer(randf_range(0.5, 1.0)).timeout
	transitioned.emit(self, "ChaseState")
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass

func on_health_changed():
	transitioned.emit(self, "HurtState")


