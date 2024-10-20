class_name Heat
extends Node

var heat: int = 0:
	set(value):
		heat = clamp(value, 0, maximum_heat)

var speed_bonus: int:
	get():
		return max(1, heat * per_heat_bonus)

@export var maximum_heat: int = 10
@export var per_heat_bonus: float = 0

func heat_up() -> void:
	heat += 2
	print('heat subiu para: ', heat)

func cool_down() -> void:
	heat -= 1
	print('heat desceu para: ', heat)
