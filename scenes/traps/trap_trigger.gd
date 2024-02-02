class_name TrapTrigger
extends Area2D

@export var traps: Array[Area2D]

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		for trap in traps:
			if trap is Area2D:
				trap.trigger_trap()
