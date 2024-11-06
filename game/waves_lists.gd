extends Node

const SIMPLE_ENEMY: String = "res://entities/enemy/simple_enemy.tscn"
const BOSS: String = "res://entities/boss/boss.tscn"

func start_lists() -> void:
	var first_wave: Array = [[SIMPLE_ENEMY, Vector2(425, 100)]]
	Waves.add_list(first_wave)
	
	var second_wave: Array = [[SIMPLE_ENEMY, Vector2(200, 100)],
								[SIMPLE_ENEMY, Vector2(650, 100)],
								[SIMPLE_ENEMY, Vector2(425, 400)]]
	Waves.add_list(second_wave)
	
	var third_wave: Array = [[SIMPLE_ENEMY, Vector2(200, 100)],
								[SIMPLE_ENEMY, Vector2(650, 250)],
								[SIMPLE_ENEMY, Vector2(200, 400)],
								[SIMPLE_ENEMY, Vector2(650, 550)]]
	Waves.add_list(third_wave)
	
	var fourth_wave: Array = [[SIMPLE_ENEMY, Vector2(425, 100)],
								[SIMPLE_ENEMY, Vector2(250, 250)],
								[SIMPLE_ENEMY, Vector2(250, 550)],
								[SIMPLE_ENEMY, Vector2(600, 250)],
								[SIMPLE_ENEMY, Vector2(600, 550)]]
	Waves.add_list(fourth_wave)
	
	var boss: Array = [[BOSS, Vector2(425, 200)]]
	Waves.add_list(boss)
