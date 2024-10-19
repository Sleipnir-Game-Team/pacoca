class_name Ball
extends CharacterBody2D


var SPEED = 150
var direction = 30
var bounce: Vector2

@onready var contact_area: ContactArea = $ContactArea

func _ready():
	velocity = Vector2(sin(deg_to_rad(direction)) * SPEED, cos(deg_to_rad(direction)) * SPEED)


func flip(normal):
	velocity = velocity.bounce(normal)
	direction = rad_to_deg(velocity.angle())

func _physics_process(_delta: float) -> void:
	move_and_slide()
