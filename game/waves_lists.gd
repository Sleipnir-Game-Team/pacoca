extends Node

var enemies_list = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_list = ["res://entities/enemy/Simple_Enemy.tscn", Vector2(300, 200)]
	Waves.add_list(enemies_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
