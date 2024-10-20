extends CharacterBody2D

class_name Player

var invincibility: bool = false

## Distance in pixels between the player's center and the held object's origin
@export var holding_distance: int = 78

## Speed at which to launch held objects
@export var launch_velocity: int = 30

@export_group('Movement', 'movement')
@export var movement_speed: int = 200

@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1

@onready var tongue: Marker2D = %Tongue
@onready var kick: Kick = %Kick
@onready var grab: Grab = %Grab
@onready var life: Life = %Life
@onready var head_animation = $head_animation as AnimatedSprite2D
@onready var tail_animation = $tail_animation as AnimatedSprite2D
@onready var hurtbox = $HurtBox as Area2D
@onready var invecibility_time = $invencibility_time as Timer
@onready var hurt_animation = $hurt_animation as AnimationPlayer

func _physics_process(_delta: float) -> void:
	velocity.x = 0
	
	var movement_direction: int = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()
	
	var mouse_position: Vector2 = get_global_mouse_position()
	var aim_direction: Vector2 = global_position.direction_to(mouse_position).clamp(Vector2(-INF, -INF), Vector2(INF, 0))
	
	if  (mouse_position.x < 0 or mouse_position.x > 810):
		rotation = rotate_toward(rotation, 0, 0.1)
	elif mouse_position.y < global_position.y:
		rotation = rotate_toward(rotation, clampf(aim_direction.angle() + PI/2, -PI/2, PI/2), 0.1)
	elif mouse_position.y > global_position.y:
		var side: float = PI/2
		if mouse_position.x <= global_position.x:
			side = -side
		rotation = rotate_toward(rotation, side, 0.1)
	
	if grab.is_holding():
		invincibility = true
		grab.held_object.global_position = tongue.global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and not grab.is_holding() and kick.can_trigger():
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		kick.trigger(attack_direction)
		head_animation.play("kick")
	elif event.is_action_pressed("player_special") and grab.can_trigger():
		invincibility = false
		var click_position: Vector2 = get_global_mouse_position()
		var attack_direction: Vector2 = global_position.direction_to(click_position)
		grab.trigger(attack_direction)

func _on_life_defeat_signal() -> void:
	# NOTE Maybe play death animation, wait a few seconds, and then actually call game_over().
	GameManager.game_over()


func _on_hurt_box_body_entered(_body: Node2D) -> void:
	# NOTE Maybe play hurt animation, give some invincibility frames and then back to normal
	if not invincibility:
		life.damage()
		invencibility_frames()

func _on_kick_animation_animation_finished() -> void:
	head_animation.play("default")

func invencibility_frames():
	invecibility_time.start()
	hurt_animation.play("hurt")
	invincibility = true

func _on_invencibility_time_timeout() -> void:
	invincibility = false
