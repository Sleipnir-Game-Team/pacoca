extends Node2D

@export var speed: float

func move(direction):
	get_parent().velocity.x = speed * direction
	get_parent().move_and_slide()
