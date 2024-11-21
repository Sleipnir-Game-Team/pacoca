extends Power

var stopped_time_timer : Timer

@export var stopped_time := 0

func _ready() -> void:
	super._ready()
	stopped_time_timer = Timer.new()
	if stopped_time > 0:
		stopped_time_timer.wait_time = stopped_time
		stopped_time_timer.one_shot = true

func _effect():
	pass
