extends CharacterBody2D

var held_object: Ball = null

## Distance in pixels between the player's center and the held object's origin
@export var holding_distance: int = 15

## Speed at which to launch held objects
@export var launch_velocity: int = 30

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var kick: AreaTrigger = %Kick
@onready var grab: AreaTrigger = %Grab
@onready var life: Life = %Life

func _physics_process(_delta: float) -> void:
	velocity.x = 0
	
	var movement_direction: int = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()
	
	if held_object != null:
		var click_position: Vector2 = get_global_mouse_position()
		var holding_direction: Vector2 = global_position.direction_to(click_position)
		held_object.position = position + (holding_direction * holding_distance)
	
	
	var aim_direction = global_position.direction_to(get_global_mouse_position())
	var aim_angle = aim_direction.angle()
	
	kick.rotation = aim_angle
	kick.position = kick.distance * aim_direction
	
	kick.position.x += kick.offset * -sin(kick.rotation)
	kick.position.y += kick.offset * cos(kick.rotation)
	
	kick.rotation += PI / 2
	
	grab.rotation = aim_angle
	grab.position = kick.distance * aim_direction
	grab.position.x += -(kick.distance / 2) * (-sin(rotation))
	grab.rotation += PI / 2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and held_object == null and kick.can_kick():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
	
		kick.trigger(attack_direction)
	elif event.is_action_pressed("player_special") and grab.can_kick():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		
		grab.trigger(attack_direction)


func handle_kick(direction: Vector2, data: Dictionary) -> void:
	var ball = data.collider as Ball
	ball.change_angle(rad_to_deg(direction.angle()))
	ball.add_heat()

func handle_grab(direction: Vector2, data: Dictionary) -> void:
	var ball = data.collider as Ball
	
	if held_object != null:
		held_object = null
		var angle_deg = rad_to_deg(direction.angle())
		print('ANGULO DE ARREMESSO: %sº' % angle_deg)
		ball.change_angle(angle_deg)
	else:
		held_object = ball


func _on_life_defeat_signal() -> void:
	# TODO Maybe play death animation, wait a few seconds, and then actually call game_over().
	GameManager.game_over()


func _on_hurt_box_body_entered(body: Node2D) -> void:
	# TODO Maybe play hurt animation, give some invincibility frames and then back to normal
	life.damage()
