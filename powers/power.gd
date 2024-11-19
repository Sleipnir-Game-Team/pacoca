extends Node
class_name Power

signal activation
signal deactivation

var active := false
var cooldown_timer : Timer

@export var cooldown_time := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_timer = Timer.new()
	if cooldown_time > 0:
		cooldown_timer.wait_time = cooldown_time
		cooldown_timer.one_shot = true
	add_child(cooldown_timer)

func activate_power():
	if !active and cooldown_timer.is_stopped():
		active = true
		_effect()
	
func _effect():
	pass

func deactivate():
	cooldown_timer.start()
	active = false
