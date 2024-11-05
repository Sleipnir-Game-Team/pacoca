extends Node

signal move(direction)

func _process(delta):
	var movement_direction = Vector2.ZERO
	if Input.is_action_pressed("player_right"):
		movement_direction.x += 1
	if Input.is_action_pressed("player_left"):
		movement_direction.x -= 1
	
	
	move.emit(movement_direction)