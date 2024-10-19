extends CharacterBody2D

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var kick: Kick = %Kick

func _physics_process(delta: float) -> void:
	velocity.x = 0
	
	var movement_direction = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and kick.can_kick():
		var click_position = get_global_mouse_position()
		var attack_direction = global_position.direction_to(click_position)
		
		kick.trigger(attack_direction)
