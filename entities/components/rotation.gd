extends Node

@export var min_angle := -180
@export var max_angle := 180

@export var rotation_speed := 10.0

@onready var target_angle : float = get_parent().rotation

func _physics_process(_delta: float) -> void:
	get_parent().rotation = rotate_toward(get_parent().rotation, target_angle, rotation_speed * _delta)
	
func rotate(direction: Vector2) -> void:
	var angle := rad_to_deg(direction.angle())
	if min_angle < angle and angle < max_angle:
		target_angle = deg_to_rad(angle)
