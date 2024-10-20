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
		print("Raio do círculo: ", radius)


func _process(_delta: float) -> void:
	if global_position.x <= initial_position.x:
		velocity.x = SPEED  
	elif global_position.x >= initial_position.x + max_distance or global_position.x >= 810 - radius - 5:
		velocity.x = -SPEED  
		
	move_and_slide()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	print("dano")
	life.damage()

func _on_life_defeat_signal() -> void:
	queue_free()
