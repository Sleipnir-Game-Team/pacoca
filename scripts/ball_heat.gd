extends Node

@export var heat := 0
@export var speed := 0
var add_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_speed = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func increment_heat():
	heat += 1
	
func speed_up():
	add_speed = heat * speed

func decresse_heat():
	if heat > 0:
		heat -= 1
