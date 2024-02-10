class_name HurtComponent
extends Area2D



@export var health_component: HealthComponent
@export var is_enemy: bool

@onready var invincibility_timer: Timer = $InvincibilityTimer

func _ready() -> void:
	area_entered.connect(on_area_entered)
	invincibility_timer.timeout.connect(on_timer_timeout)
	
	if is_enemy:
		collision_mask = 16
	else :
		collision_mask = 32
	
func on_area_entered(area: Area2D):
	if area is HitboxComponent and invincibility_timer.is_stopped():
		health_component.hurt(area.damage)
		invincibility_timer.start()

func on_timer_timeout():
	var areas = get_overlapping_areas()
	if not areas.is_empty():
		for area in areas:
			health_component.hurt(area.damage)
			invincibility_timer.start()
