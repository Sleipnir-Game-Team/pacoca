extends Node

var enemies_list: Array[Array] = []

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_list = [
		["res://entities/enemy/simple_enemy.tscn", Vector2(566, 422)],
		["res://entities/enemy/simple_enemy.tscn", Vector2(665, 622)]
	]
	read_lists(enemies_list)

func read_lists(enemies: Array[Array]) -> void:
	for enemy in enemies:
		spawn_enemies(enemy[0], enemy[1])

func spawn_enemies(enemy_scene: String, position: Vector2) -> void:
	var enemy: CharacterBody2D = load(enemy_scene).instantiate()
	add_sibling.call_deferred(enemy)
	enemy.global_position = position

func next_wave() -> void:
	pass
