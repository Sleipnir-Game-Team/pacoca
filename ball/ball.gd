class_name Ball
extends CharacterBody2D

@export var speed: int = 200

var grabber: Node2D = null

@export var rotation_speed_factor: float = 0.02

@onready var movement: Node = %Movement
@onready var contact_area: ContactArea = %ContactArea
@onready var heat: Heat = %Heat
@onready var sprite: Sprite2D = %Sprite2D
@onready var player: Player = $"../Player"


func _ready() -> void:
	movement.speed = speed * heat.speed_bonus

func _physics_process(delta: float) -> void:
	movement.move(Vector2(cos(rotation),sin(rotation)))
	
	if grabber == null: #gira
		sprite.rotation += velocity.length() * rotation_speed_factor * delta


func flip(normal: Vector2) -> void:
	_play_hit_sound()
	
	heat.cool_down()
	
	normal = normal.normalized()
	var dot_product: float = velocity.dot(normal)
	var reflection_angle: float = (velocity - 2 * dot_product * normal).angle()
	rotation = reflection_angle


func _on_grab(grabber) -> void:
	self.grabber = grabber

func _on_throw(angle: float) -> void:
	_play_hit_sound()
	
	rotation_degrees = angle
	grabber = null

func _on_kick(angle: float):
	heat.heat_up()
	
	_play_hit_sound()
	
	rotation_degrees = angle

func _play_hit_sound() -> void:
	if heat.is_burning == true: AudioManager.play_global("ball.hot.hit")
	else: AudioManager.play_global("ball.cold.hit")

func _on_heat_changed(new_heat):
	movement.speed = speed * heat.speed_bonus
