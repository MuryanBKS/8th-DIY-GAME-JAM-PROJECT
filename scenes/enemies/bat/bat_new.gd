extends CharacterBody2D


var target: CharacterBody2D
var is_summoned = false : set = set_summon_state



func set_summon_state(value):
	if value:
		$StateMachine.initial_state = $StateMachine/ChaseState
	else:
		return
	is_summoned = value
