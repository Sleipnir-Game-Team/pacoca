extends Node

var power_type
const power_drop_instance = preload("res://powers/scenes/power_drop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var powers_array = get_tree().get_nodes_in_group('Powers')
	print(powers_array)
	power_type = powers_array.pick_random().get_scene_file_path()
	print(power_type)
	
	var drop = power_drop_instance.instantiate()
	get_parent().call_deferred("add_child", drop)
	drop.position = Vector2(401, 100)
	drop.power_type = power_type
	queue_free()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
