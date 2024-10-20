extends CharacterBody2D

var SPEED: int = 150
var max_distance: int = 85  
var radius: int

@onready var life: Life = %Life
@onready var initial_position: Vector2 = global_position
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _ready() -> void:
	# Acessa o nó CollisionShape2D filho
	# e verifica se o shape é um CircleShape2D
	var shape: Shape2D = collision_shape_2d.shape
	if shape is CircleShape2D:
		radius = shape.radius  # Pega o raio do círculo



func _on_hit_box_body_entered(body: Node2D) -> void:
	life.damage()


func _on_life_defeat_signal() -> void:
	queue_free()
	Waves.pop_enemy()
