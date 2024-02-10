class_name HealthComponent
extends Node


@export var health: int


func hurt(damage: int):
	health -= damage
	if health <= 0:
		die()
	

func die():
	pass
