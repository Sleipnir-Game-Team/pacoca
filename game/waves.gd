extends Node

var enemy_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_enemy(enemie_path, position):
	var enemy = [enemie_path, position]
	enemy_list.append(enemy)
	
func pop_enemy(enemy_index):
	enemy_list.pop_at(enemy_index)
