class_name Heat
extends Node

signal heat_changed(new_heat)

var heat: float = 0:
	set(value):
		var old_heat = heat
		heat = clamp(value, 0, maximum_heat)
		if heat != old_heat:
			heat_changed.emit(heat)

var speed_bonus: int:
	get():
		return max(1, 1 + heat * per_heat_bonus)

var is_burning: bool:
	get():
		return heat >= burning_trashold

@export var maximum_heat: int = 4
@export var per_heat_bonus: float = 0.25
@export var heat_loss: float = 1
@export var heat_gain: float = 1
@export var burning_trashold: int = 3

func heat_up() -> void:
	heat = heat + heat_gain

func cool_down() -> void:
	heat = heat - heat_loss
