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

#func trigger_kick() -> void:
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and cooldown_timer.is_stopped():
		var click_position = get_global_mouse_position()
		var attack_direction = global_position.direction_to(click_position)
		cooldown_timer.start()
		
		rotation = atan2(attack_direction.y, attack_direction.x) + (PI / 2)
		position = radius * attack_direction
		
		collision_shape.set_deferred('disabled', false)
		duration_timer.start()
		
