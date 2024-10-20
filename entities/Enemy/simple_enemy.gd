extends CharacterBody2D

var rng = RandomNumberGenerator.new()

@onready var hurt_box: Area2D = %HurtBox
@onready var life: Life = %Life
@onready var ball: Ball = get_tree().get_first_node_in_group('Ball')
@onready var sprite: Sprite2D = $Sprite2D

var list_sprite = ["res://assets/alien A.png", "res://assets/alien B.png", "res://assets/alien C.png"]

func _ready() -> void:
	# Gera um número aleatório entre 0 e 2
	var num_sprite = rng.randi_range(0, list_sprite.size() - 1)
	
	# Carrega a textura a partir do caminho
	sprite.texture = load(list_sprite[num_sprite])

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(ball):
		ball = get_tree().get_first_node_in_group('Ball')
	else:
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
