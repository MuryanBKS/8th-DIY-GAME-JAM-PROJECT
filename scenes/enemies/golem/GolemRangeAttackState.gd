extends State

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer
@export var arm_projectile: PackedScene
@export var range_attack_node: Node2D
@export var hand_marker: Marker2D

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	animation_player.play("range_attack")
	await animation_player.animation_finished
	range_attack()
	await get_tree().create_timer(2).timeout
	transitioned.emit(self, "IdleState")
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	
	
func update(delta: float) -> void:
	if owner.move_direction.x > 0:
		range_attack_node.scale.x = 1
	elif owner.move_direction.x < 0:
		range_attack_node.scale.x = -1
	
func physics_update(delta: float) -> void:
	pass



func range_attack():
	var arm_projectile_instance = arm_projectile.instantiate()
	arm_projectile_instance.global_position = hand_marker.global_position
	owner.get_parent().add_child(arm_projectile_instance)

func on_health_changed():
	transitioned.emit(self, "HurtState")

