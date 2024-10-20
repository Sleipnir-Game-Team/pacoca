extends Node

@export var speed: float

func move(direction: Vector2) -> void:
	get_parent().velocity = speed * direction
	get_parent().move_and_slide()
