extends Node

func start_lists() -> void:
	var first_wave: Array = [["res://entities/enemy/simple_enemy.tscn", Vector2(300, 200)]]
	var second_wave: Array = [["res://entities/enemy/simple_enemy.tscn", Vector2(300, 400)]]
	Waves.add_list(first_wave)
	Waves.add_list(second_wave)
