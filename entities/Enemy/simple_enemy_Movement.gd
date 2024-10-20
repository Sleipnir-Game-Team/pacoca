extends CharacterBody2D

var initial_position: Vector2  
var SPEED = 150
var max_distance = 85  
var radius
@onready var life: Life = %life



func _ready() -> void:
	initial_position = global_position  
	# Acessa o nó CollisionShape2D filho
	var collision_shape = $CollisionShape2D
	
	# Verifica se o shape é um CircleShape2D
	var shape = collision_shape.shape
	if shape is CircleShape2D:
		radius = shape.radius  # Pega o raio do círculo
		print("Raio do círculo: ", radius)


func _process(delta: float) -> void:
	
	if global_position.x <= initial_position.x:
		velocity.x = SPEED  
	elif global_position.x >= initial_position.x + max_distance or global_position.x >= 810 - radius - 5:
		velocity.x = -SPEED  
		
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	life.damage()


func _on_life_defeat_signal() -> void:
	queue_free()
