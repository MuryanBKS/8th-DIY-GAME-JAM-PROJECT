class_name HealthComponent
extends Node

signal health_changed
signal died

@export var health: int


func hurt(damage: int):
	health_changed.emit()
	health -= damage
	if health <= 0:
		health = 0
		
		
func get_health() -> int:
	return health
