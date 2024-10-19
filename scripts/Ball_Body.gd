extends CharacterBody2D

@export var base_speed = 400

@onready var heat := $Heat as Node2D
var direction

func _ready() -> void:
	var speed = base_speed + heat.add_speed
	direction = Vector2(200, 150).normalized() * speed

func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(direction * delta)
	
	if collision_info:
		print("Colidiu com:", collision_info.get_collider().name)  
		direction = direction.bounce(collision_info.get_normal())
