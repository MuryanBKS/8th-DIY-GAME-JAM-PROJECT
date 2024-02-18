extends Resource
class_name PotStaus

var attack_bonus: int

var bonus_types = {"Attack": attack_bonus}

func get_bonus(bonus_type, bonus_value):
	for type in bonus_types.keys():
		if type == bonus_type:
			bonus_types[type] += bonus_value
