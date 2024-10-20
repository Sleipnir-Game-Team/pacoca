class_name Heat
extends Node

var heat: int = 0:
	set(value):
		heat = clamp(value, 0, maximum_heat)

var speed_bonus: int:
	get():
		return max(1, heat * per_heat_bonus)

var is_burning: bool:
	get():
		if heat >= burning_trashold:
			return true
		else:
			return false

@export var maximum_heat: int = 10
@export var per_heat_bonus: float = 1.10
@export var heat_loss: float = 1
@export var heat_gain: float = 1.5
@export var burning_trashold: int = 7


func heat_up() -> void:
	heat = heat + heat_gain


func cool_down() -> void:
	heat = heat - heat_loss
