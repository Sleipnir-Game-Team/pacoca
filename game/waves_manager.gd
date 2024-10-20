extends Node

var enemies_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_list = [
		["res://entities/enemy/Simple_Enemy.tscn", Vector2(566, 422)],
		["res://entities/enemy/Simple_Enemy.tscn", Vector2(665, 622)]]
	read_lists(enemies_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func read_lists(enemies):
	for enemy in enemies:
		spawn_enemies(enemy[0], enemy[1])
	
func spawn_enemies(enemie, position):
	var enemies_initiate = load(enemie).instantiate()
	get_parent().call_deferred("add_child", enemies_initiate)
	enemies_initiate.global_position = position

func next_wave():
	
	pass
	
