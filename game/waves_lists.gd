extends Node

func start_lists() -> void:
	var first_wave: Array = [["res://entities/enemy/Simple_Enemy.tscn", Vector2(425, 100)]]
	var second_wave: Array = [["res://entities/enemy/Simple_Enemy.tscn", Vector2(200, 100)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(650, 100)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(425, 400)]]
	var third_wave: Array = [["res://entities/enemy/Simple_Enemy.tscn", Vector2(200, 100)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(650, 250)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(200, 400)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(650, 550)]]
	var fourth_wave: Array = [["res://entities/enemy/Simple_Enemy.tscn", Vector2(425, 100)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(250, 250)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(250, 550)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(600, 250)],
								["res://entities/enemy/Simple_Enemy.tscn", Vector2(600, 550)]]
	var boss: Array = [["res://entities/boss/boss.tscn", Vector2(425, 200)]]
	Waves.add_list(first_wave)
	Waves.add_list(second_wave)
	Waves.add_list(third_wave)
	Waves.add_list(fourth_wave)
	Waves.add_list(boss)
	
