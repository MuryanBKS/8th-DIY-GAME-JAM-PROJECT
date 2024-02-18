extends State
class_name WarriorNpcState


@export var switch_area: Area2D



func enter() -> void:
	switch_area.body_entered.connect(on_body_entered)
	
	
func exit() -> void:
	switch_area.body_entered.disconnect(on_body_entered)
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass


func on_body_entered(body: Node2D):
	if body is Player:
		GameManager.player_changed.emit("Warrior")
		transitioned.emit(self, "IdleState")
