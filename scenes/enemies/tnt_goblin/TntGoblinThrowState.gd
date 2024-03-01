extends State

@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer
@export var tnt_scene: PackedScene
@export var visuals: Node2D
@export var hand_marker: Marker2D

func enter() -> void:
	health_component.health_changed.connect(on_health_changed)
	animation_player.play("throw")
	await animation_player.animation_finished
	transitioned.emit(self, "RunAwayState")
	
func exit() -> void:
	health_component.health_changed.disconnect(on_health_changed)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if owner.move_direction.x > 0:
		visuals.scale.x = 1
	elif owner.move_direction.x < 0:
		visuals.scale.x = -1


func throw():
	var tnt_scene_instance = tnt_scene.instantiate()
	tnt_scene_instance.global_position = hand_marker.global_position
	owner.get_parent().add_child(tnt_scene_instance)


func on_health_changed():
	transitioned.emit(self, "HurtState")

