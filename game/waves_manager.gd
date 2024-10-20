extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var wave: Array[Array] = [
		["res://entities/enemy/simple_enemy.tscn", Vector2(566, 422)],
		["res://entities/enemy/simple_enemy.tscn", Vector2(665, 622)]
	]
	
	run_wave(wave)

func run_wave(wave: Array) -> void:
	for enemy: Array in wave:
		spawn_enemy(enemy[0], enemy[1])

func spawn_enemy(enemy_scene: String, position: Vector2) -> void:
	var enemy: CharacterBody2D = load(enemy_scene).instantiate()
	add_sibling.call_deferred(enemy)
	enemy.global_position = position

func next_wave() -> void:
	pass
