class_name Ball
extends CharacterBody2D


var SPEED: int = 15
var direction: Vector2 = Vector2(200, 150).normalized()
var bounce: Vector2

@onready var contact_area: ContactArea = %ContactArea

func _ready() -> void:
	contact_area.bounce_vector_calculated.connect(_on_bounce_vector_calculated)

func _on_bounce_vector_calculated(vetor_bounce: Vector2) -> void:
	bounce = (vetor_bounce)
	print("Vetor de bounce recebido:", vetor_bounce)
	
	for body in contact_area.get_overlapping_bodies():
		direction = direction.bounce(bounce.normalized())
	
	bounce = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED * SPEED # lol, lmao even
	move_and_slide()
