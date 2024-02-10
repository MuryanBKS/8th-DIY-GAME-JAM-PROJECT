extends State
class_name BatIdleState

@export var chase_area: Area2D

func enter():
	chase_area.body_entered.connect(on_body_entered)
	
	
	
func on_body_entered(body: Node2D):
	transitioned.emit(self, "ChaseState")
