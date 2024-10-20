class_name Ball
extends CharacterBody2D


var speed: int = 150
var direction: float = 30
var bounce: Vector2

@onready var contact_area: ContactArea = $ContactArea
@onready var heat: Heat = %Heat

func _ready() -> void:
	var base_velocity: Vector2 = Vector2(sin(deg_to_rad(direction)), cos(deg_to_rad(direction))) 
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(sin(deg_to_rad(direction)) * speed * heat.speed_bonus, cos(deg_to_rad(direction)) * speed * heat.speed_bonus)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func change_angle(angle: float) -> void:
	direction = angle
	var base_velocity: Vector2 = Vector2(cos(deg_to_rad(direction)), sin(deg_to_rad(direction)))
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(cos(deg_to_rad(direction)) * speed * heat.speed_bonus, sin(deg_to_rad(direction)) * speed * heat.speed_bonus)
	


func flip(normal: Vector2) -> void:
	heat.cool_down()
	velocity = velocity.bounce(normal)
	direction = rad_to_deg(velocity.angle())
