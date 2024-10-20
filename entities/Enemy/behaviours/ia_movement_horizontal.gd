extends Node

var direction: int = 1

@export var movement_length: float

@onready var parent: Node2D = get_parent()
@onready var initial_position: Vector2 = parent.global_position

signal move(direction: Vector2)

func _physics_process(_delta: float) -> void:
	if parent.global_position.x <= initial_position.x - movement_length/2 or parent.global_position.x >= initial_position.x + movement_length/2 or parent.position.x >= 729 or parent.position.x <= 81:
		direction *= -1
	
	move.emit(Vector2(direction, 0))
