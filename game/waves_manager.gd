extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_list = [
		["res://entities/enemy/simple_enemy.tscn", Vector2(566, 422)],
		["res://entities/enemy/simple_enemy.tscn", Vector2(665, 622)]
	]
	
	read_lists(enemies_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func read_lists():
	var enemies = Waves.return_list()
	for enemy in enemies:
		spawn_enemy(enemy[0], enemy[1])

func spawn_enemy(enemy_scene: String, position: Vector2) -> void:
	var enemy: CharacterBody2D = load(enemy_scene).instantiate()
	add_sibling.call_deferred(enemy)
	enemy.global_position = position

func next_wave() -> void:
	pass
