class_name Ball
extends CharacterBody2D


var speed: int = 150
var direction: float = 30
var bounce: Vector2

@onready var contact_area: ContactArea = $ContactArea

func _ready():
	velocity = Vector2(sin(deg_to_rad(direction)) * speed, cos(deg_to_rad(direction)) * speed)

func _physics_process(_delta: float) -> void:
	move_and_slide()


func flip(normal: Vector2):
	velocity = velocity.bounce(normal)
	direction = rad_to_deg(velocity.angle())
