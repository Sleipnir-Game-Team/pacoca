extends CharacterBody2D

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var kick: Kick = %Kick

func _physics_process(_delta: float) -> void:
	velocity.x = 0
	
	var movement_direction: int = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and kick.can_kick():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		
		kick.trigger(attack_direction)

func handle_kick(direction: Vector2, data: Dictionary) -> void:
	var ball = data.collider as Ball
	ball.direction = direction

func handle_grab() -> void:
	pass

func _on_life_defeat_signal() -> void:
	# TODO Maybe play death animation, wait a few seconds, and then actually call game_over().
	GameManager.game_over()
