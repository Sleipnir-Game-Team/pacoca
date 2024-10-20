extends CharacterBody2D

@onready var hurt_box: Area2D = %HurtBox
@onready var life: Life = %Life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')

func _physics_process(_delta: float) -> void:
	var aim_angle: float = global_position.angle_to_point(ball.global_position)
	if deg_to_rad(10.0) < aim_angle and aim_angle < deg_to_rad(170.0):
		rotation = rotate_toward(rotation, aim_angle - (PI/2), _delta)

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Ball:
		life.damage()

func _on_life_defeat_signal() -> void:
	# NOTE Maybe play a death sound, or a death animation, then run a timer and finally actually die lmao
	queue_free()
	Waves.pop_enemy()
