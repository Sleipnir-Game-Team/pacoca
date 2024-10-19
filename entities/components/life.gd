extends Node

@export var max_life: int = 3
var entity_life: int

signal defeat_signal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	entity_life = max_life

func damage() -> void:
	if entity_life > 0:
		entity_life -= 1
		
	if entity_life == 0:
		defeat_signal.emit()

func recover() -> void:
	if entity_life < max_life and entity_life > 0:
		entity_life += 1
