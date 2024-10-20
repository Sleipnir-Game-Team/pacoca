class_name Ball
extends CharacterBody2D

const yellow_outline: ShaderMaterial = preload("res://ball/outline.tres")

@export var speed: int = 200
var direction: float = 30
var bounce: Vector2
var burning: bool
var grabbed: bool = false
var atual_rotation: float

@export var rotation_speed_factor: float = 0.02
@onready var contact_area: ContactArea = $ContactArea
@onready var heat: Heat = %Heat
@onready var sprite: Sprite2D = $Sprite2D
@onready var player: Player = $"../Player"

func _ready() -> void:
	var base_velocity: Vector2 = Vector2(sin(deg_to_rad(direction)), cos(deg_to_rad(direction))) 
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(sin(deg_to_rad(direction)) * speed * heat.speed_bonus, cos(deg_to_rad(direction)) * speed * heat.speed_bonus)
	burning = heat.is_burning


func _physics_process(delta: float) -> void:
	move_and_slide()
	
	#sprite da bola girar e parar de girar quando grabbed
	var direction_to_player: Vector2 = player.global_position - global_position
	var angle_to_player: float = direction_to_player.angle()
	
	if grabbed == false: #gira
		sprite.rotation += velocity.length() * rotation_speed_factor * delta
	elif grabbed == true:#desgira
		sprite.rotation = angle_to_player + atual_rotation + PI


func change_angle(angle: float) -> void:
	# NOTE SOM AQUI DA BOLA BATENDO - INIMIGO/JOGADOR BATENDO
	direction = angle
	var base_velocity: Vector2 = Vector2(cos(deg_to_rad(direction)), sin(deg_to_rad(direction)))
	velocity = base_velocity * speed * heat.speed_bonus
	velocity = Vector2(cos(deg_to_rad(direction)) * speed * heat.speed_bonus, sin(deg_to_rad(direction)) * speed * heat.speed_bonus)
	grabbed = false

func flip(normal: Vector2) -> void:
	# NOTE SOM AQUI DA BOLA BATENDO - PAREDE
	heat.cool_down()
	
	normal = normal.normalized()
	var dot_product: float = velocity.dot(normal)
	var reflection_angle: float = rad_to_deg((velocity - 2 * dot_product * normal).angle())
	direction = reflection_angle
	var base_velocity: Vector2 = Vector2(cos(deg_to_rad(direction)), sin(deg_to_rad(direction)))
	
	velocity = base_velocity * speed * heat.speed_bonus

func set_outline(value: bool) -> void:
	if value:
		sprite.material = yellow_outline
	else:
		sprite.material = null

func _on_grab_hold_to_stop() -> void: # NOTE SOM AQUI DA BOLA MORDIDA
	grabbed = true
	atual_rotation = sprite.rotation
