extends Node2D

@export var movement_length: float

var initial_position: Vector2

var direction = 1

signal move(direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_parent().position.x)
	if global_position.x <= initial_position.x - movement_length/2 or global_position.x >= initial_position.x + movement_length/2 or get_parent().position.x >= 729 or get_parent().position.x <= 81:
		direction *= -1
	
	
	move.emit(Vector2(direction, 0))
