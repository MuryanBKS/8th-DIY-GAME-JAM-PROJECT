extends State
class_name BatIdleState


@export var chase_area: Area2D
@export var animation_player: AnimationPlayer


func enter():
	chase_area.body_entered.connect(on_body_entered)
	animation_player.play("idle")
	
	

func exit():
	chase_area.body_entered.disconnect(on_body_entered)
	

func on_body_entered(body: Node2D):
	owner.target = body
	transitioned.emit(self, "ChaseState")
