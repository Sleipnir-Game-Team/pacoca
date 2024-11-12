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
@export var burning_trashold: int = 3

func heat_up(value = 1) -> void:
	heat = heat + value
	Logger.info("A bola esquentou em "+str(value))

func cool_down(value = 1) -> void:
	heat = heat - value
	Logger.info("A bola esfriou em "+str(value))
