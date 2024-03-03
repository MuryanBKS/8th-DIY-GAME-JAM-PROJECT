extends CharacterBody2D

var move_direction: Vector2
var is_summoned = false : set = set_summon_state


func _ready() -> void:
	GameManager.game_clear.connect(on_game_clear)


func on_game_clear():
	$StateMachine.current_state.transitioned.emit($StateMachine.current_state, "DiedState")
	

func set_summon_state(value):
	if value:
		$StateMachine.initial_state = $StateMachine/ChaseState
	else:
		return
	is_summoned = value


