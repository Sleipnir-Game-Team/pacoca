extends CharacterBody2D

@onready var life: Life = %life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Ball:
		life.damage()

func _on_life_defeat_signal() -> void:
	queue_free()
	Waves.pop_enemy()
