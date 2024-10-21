extends Node

@onready var wave_lists: Node = $Wave_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Waves.restart()
	wave_lists.start_lists()
	var wave: Array = Waves.return_list()
	run_wave(wave)

func _process(_delta: float) -> void:
	if Waves.has_pass == true:
		var waves: Array = Waves.return_list()
		if waves.size() > 0:
			print("Nova wave")
			print(waves[0])
			run_wave(waves)
		else:
			UI_Controller.changeScreen("res://ui/menu/victory_menu.tscn", get_tree().root)
		Waves.has_pass = false

func run_wave(wave: Array) -> void:
	for enemy: Array in wave:
		spawn_enemy(enemy[0], enemy[1])

func spawn_enemy(enemy_scene: String, position: Vector2) -> void:
	var enemy: CharacterBody2D = load(enemy_scene).instantiate()
	add_sibling.call_deferred(enemy)
	enemy.global_position = position

func next_wave() -> void:
	pass
