extends CharacterBody2D

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var kick_hitbox: Area2D = %KickHitbox
@onready var kick_collision: CollisionShape2D = %KickCollision
@onready var kick_cooldown_timer: Timer = %KickCooldownTimer
@onready var kick_duration_timer: Timer = %KickDurationTimer

func _ready() -> void:
	kick_cooldown_timer.wait_time = kick_cooldown_seconds
	kick_duration_timer.timeout.connect(kick_collision.set_deferred.bind('disabled', 'false'))

func _physics_process(delta: float) -> void:
	velocity.x = 0
	
	var movement_direction = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and kick_cooldown_timer.is_stopped():
		var click_position = get_global_mouse_position()
		var attack_direction = global_position.direction_to(click_position)
		kick_cooldown_timer.start()
		
		kick_hitbox.rotation = atan2(attack_direction.y, attack_direction.x) + (PI / 2)
		kick_hitbox.position = 15 * attack_direction
		kick_collision.set_deferred('disabled', false)
		kick_duration_timer.start()
		
