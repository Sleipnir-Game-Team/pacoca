extends CharacterBody2D

var held_object: Ball = null

## Distance in pixels between the player's center and the held object's origin
@export var holding_distance: int = 15

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var kick: AreaTrigger = %Kick
@onready var grab: AreaTrigger = %Grab

func _physics_process(_delta: float) -> void:
	velocity.x = 0
	
	var movement_direction: int = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()
	
	if held_object != null:
		var click_position: Vector2 = get_global_mouse_position()
		var holding_direction: Vector2 = global_position.direction_to(click_position)
		held_object.position = position + (holding_direction * holding_distance)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and kick.can_kick():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		
		kick.trigger(attack_direction)
	elif event.is_action_pressed("player_special") and kick.can_kick():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		
		grab.trigger(attack_direction)


func handle_kick(direction: Vector2, data: Dictionary) -> void:
	var ball = data.collider as Ball
	ball.direction = direction

func handle_grab(direction: Vector2, data: Dictionary) -> void:
	var ball = data.collider as Ball
	
	if held_object != null:
		held_object = null
		ball.direction = direction
	else:
		ball.direction = Vector2.ZERO
		held_object = ball


func _on_life_defeat_signal() -> void:
	# TODO Maybe play death animation, wait a few seconds, and then actually call game_over().
	GameManager.game_over()
