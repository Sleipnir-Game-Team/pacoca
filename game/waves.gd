extends Node

var enemies_waves_lists = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_list(enemies_list):
	enemies_waves_lists.append(enemies_list)

func add_enemy(enemie_path, position, enemies_list):
	var enemy = [enemie_path, position]
	enemies_list.append(enemy)
	
func pop_enemy():
	enemies_waves_lists[0].remove_at(0)
	if enemies_waves_lists[0].size() == 0:
		pass_list()

func pass_list():
	if enemies_waves_lists.size() > 0:
		enemies_waves_lists.remove_at(0)
		
func return_list():
	return enemies_waves_lists[0]
