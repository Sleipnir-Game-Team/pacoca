class_name Life
extends Node


@export var max_life: int = 3
@onready var entity_life: int = max_life

signal defeat_signal

func damage() -> void:
	if entity_life > 0:
		entity_life -= 1
		
	if entity_life == 0:
		defeat_signal.emit()

func recover() -> void:
	if entity_life < max_life and entity_life > 0:
		entity_life += 1
