extends Node

var waves: Waves = Waves.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_wave: Array = ["res://entities/enemy/Simple_Enemy.tscn", Vector2(300, 200)]
	waves.add_list(first_wave)
