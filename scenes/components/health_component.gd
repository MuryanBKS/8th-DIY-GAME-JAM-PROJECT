class_name HealthComponent
extends Node

signal health_changed


@export var health: float


func hurt(damage: float):
	health -= damage
	health_changed.emit()
	if health <= 0:
		health = 0
		
		
func get_health() -> float:
	return health
