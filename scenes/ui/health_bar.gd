extends ProgressBar


@onready var damage_bar: ProgressBar = $DamageBar
@onready var timer: Timer = $Timer


var health = 0 : set = _set_health


func init_health(_health):
	max_value = _health
	health = _health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
	
func _set_health(new_health):
	var previous_health = health
	health = min(max_value, new_health)
	value = health
	
	if health < previous_health:
		timer.start()
	else :
		damage_bar.value = health
	
	if health <= 0:
		hide()
		$"../Label".hide()

func _on_timer_timeout() -> void:
	damage_bar.value = health
