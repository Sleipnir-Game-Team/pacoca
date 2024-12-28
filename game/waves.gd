extends Node

var waves: Array[Array] = []
var has_pass: bool = false

signal changed_wave

func add_list(wave: Array) -> void:
	waves.append(wave)

func add_enemy(enemy_path: String, position: Vector2, wave: Array) -> void:
	var enemy: Array = [enemy_path, position]
	wave.append(enemy)
	
func pop_enemy() -> void:
	waves[0].remove_at(0)
	if waves[0].size() == 0:
		pass_list()

func pass_list() -> void:
	has_pass = true
	changed_wave.emit()
	if waves.size() > 0:
		waves.remove_at(0)
	else:
		pass
		
func return_list() -> Array:
	if waves.size() > 0:
		return waves[0]
	else:
		return waves
		
func restart() -> void:
	waves = []
