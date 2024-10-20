class_name Ball
extends CharacterBody2D


var speed: int = 150
var direction: float = 30
var bounce: Vector2

@onready var contact_area: ContactArea = $ContactArea
@onready var heat := $Heat as Node2D

func _ready() -> void:
	velocity = Vector2(sin(deg_to_rad(direction)) * speed * heat.add_speed, cos(deg_to_rad(direction)) * speed * heat.add_speed)

func _physics_process(_delta: float) -> void:
	move_and_slide()


func change_angle(angle: float) -> void:
	direction = angle
	velocity = Vector2(cos(deg_to_rad(direction)) * speed * heat.add_speed, sin(deg_to_rad(direction)) * speed * heat.add_speed)

func flip(normal: Vector2) -> void:
	velocity = velocity.bounce(normal)
	direction = rad_to_deg(velocity.angle())

func add_heat():
	heat.increment_heat()
	print(heat.heat)
