class_name Kick
extends Area2D

@export var cooldown_seconds: float = 1
@export var radius: int = 15

@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var cooldown_timer: Timer = %CooldownTimer
@onready var duration_timer: Timer = %DurationTimer

func _ready() -> void:
	# Adjust cooldown time according to exported property
	cooldown_timer.wait_time = cooldown_seconds
	
	# Every time the kick duration is over, disable the collision shape
	duration_timer.timeout.connect(collision_shape.set_deferred.bind('disabled', 'false'))

func trigger(direction: Vector2) -> void:
	cooldown_timer.start()
	
	rotation = atan2(direction.y, direction.x) + (PI / 2)
	position = radius * direction
	
	collision_shape.set_deferred('disabled', false)
	duration_timer.start()

func can_kick() -> bool:
	return cooldown_timer.is_stopped()
