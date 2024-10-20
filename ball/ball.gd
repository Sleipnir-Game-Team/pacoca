class_name Ball
extends CharacterBody2D


@export var speed: int = 200
var direction: float = 30
var bounce: Vector2
var burning: bool
var grabed: bool = false

@export var rotation_speed_factor: float = 0.02
@onready var contact_area: ContactArea = $ContactArea
@onready var heat: Heat = %Heat
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	var base_velocity: Vector2 = Vector2(sin(deg_to_rad(direction)), cos(deg_to_rad(direction))) 
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(sin(deg_to_rad(direction)) * speed * heat.speed_bonus, cos(deg_to_rad(direction)) * speed * heat.speed_bonus)
	burning = heat.is_burning

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if grabed == false:
		sprite.rotation += velocity.length() * rotation_speed_factor * delta
	elif grabed == true:
		print("era pra estar funcionando")
		sprite.rotation = velocity.length() * rotation_speed_factor



func change_angle(angle: float) -> void:
	direction = angle
	var base_velocity: Vector2 = Vector2(cos(deg_to_rad(direction)), sin(deg_to_rad(direction)))
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(cos(deg_to_rad(direction)) * speed * heat.speed_bonus, sin(deg_to_rad(direction)) * speed * heat.speed_bonus)
	grabed = false
	
	#som de bola kikando, colocar if burning para saber se está quente
	

func flip(normal: Vector2) -> void:
	heat.cool_down()
	
	normal = normal.normalized()
	var dot_product: float = velocity.dot(normal)
	var reflection_angle: float = rad_to_deg((velocity - 2 * dot_product * normal).angle())
	direction = reflection_angle
	var base_velocity: Vector2 = Vector2(cos(deg_to_rad(direction)), sin(deg_to_rad(direction)))
	
	velocity = base_velocity * speed * heat.speed_bonus
	
	#som de bola kikando, colocar if burning para saber se está quente


func _on_grab_hold_to_stop() -> void: #som de bola mordida
	print("mordido")
	grabed = true
	print(grabed)
