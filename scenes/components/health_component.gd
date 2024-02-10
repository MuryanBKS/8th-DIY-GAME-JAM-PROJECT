class_name HealthComponent
extends Node

signal health_changed

@export var health: int


func hurt(damage: int):
	health_changed.emit()
	health -= damage
	if health <= 0:
		die()
	

func die():
	pass
