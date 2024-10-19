extends CharacterBody2D


var SPEED = 15
var direction: Vector2 = Vector2(200, 150).normalized() * SPEED
var bounce: Vector2

@onready var area2D = get_node("contac_area")

func _ready() -> void:
	area2D.connect("bounce_vector_calculated", Callable(self, "_on_bounce_vector_calculated"))


func _on_bounce_vector_calculated(vetor_bounce: Vector2):
	bounce = (vetor_bounce)
	print("Vetor de bounce recebido:", vetor_bounce)
	
	for body in area2D.get_overlapping_bodies():
		direction = direction.bounce(bounce.normalized())
		
	bounce = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()
	
