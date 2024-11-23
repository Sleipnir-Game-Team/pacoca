extends Power

var stopped_time_timer : Timer

@export var stopped_time := 0

func _ready() -> void:
	super._ready()
	stopped_time_timer = Timer.new()
	if stopped_time > 0:
		stopped_time_timer.wait_time = stopped_time
		stopped_time_timer.one_shot = true
	add_child(stopped_time_timer)

func _effect() -> void:
	print("ZA WARUDO!")
	stopped_time_timer.timeout.connect(_deactivate, CONNECT_ONE_SHOT)
	stopped_time_timer.start()
	var stoppable_nodes := get_parent().get_tree().get_nodes_in_group("Time_stoppable")
	for nodes in stoppable_nodes:
		nodes.is_stopped = true
	get_parent().is_stopped = false
	
	
func return_time() -> void:
	print("Toki wa Ugokidasu")
	var stoppable_nodes := get_parent().get_tree().get_nodes_in_group("Time_stoppable")
	for nodes in stoppable_nodes:
		nodes.is_stopped = false
	
func _deactivate() -> void:
	super._deactivate()
	return_time()
