extends StaticBody2D

@export var is_opened := false : set = set_chest 


func set_chest(value):
	if value:
		%ChestSprite2D.frame = 1
	else:
		%ChestSprite2D.frame = 2
		
