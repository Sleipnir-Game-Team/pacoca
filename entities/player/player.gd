extends CharacterBody2D

class_name Player

#TODO isso não é aq, é do grab
## Distance in pixels between the player's center and the held object's origin
@export var holding_distance: int = 78

#TODO isso não é aq, é do grab
## Speed at which to launch held objects
@export var launch_velocity: int = 30

#TODO isso não é aq, é do movemento
@export_group('Movement', 'movement')
@export var movement_speed: int = 200

#TODO isso não é aq, é do kick
@export_group('Kick', 'kick')
@export var kick_cooldown_seconds: float = 1
@export var kick_buffering_duration_seconds: float = 0.1

#TODO isso não é aq, é do grab
@export_group('Grab', 'grab')
@export var grab_buffering_duration_seconds: float = 0.1

@onready var tongue: Marker2D = %Tongue
@onready var kick: Kick = %Kick
@onready var grab: Grab = %Grab
@onready var life: Life = %Life
@onready var head_animation = $head_animation as AnimatedSprite2D
@onready var tail_animation = $tail_animation as AnimatedSprite2D
@onready var hurtbox = $HurtBox as Area2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

#TODO isso não é aq, é do kick
var kick_buffering = false
var kick_buffering_duration = 0
var attack_direction: Vector2

#TODO isso não é aq, é do grab
var grab_buffering = false
var grab_buffering_duration = 0
var grab_direction: Vector2

func _ready():
	life.damage_received.connect(animation_player.play_animation.bind('hurt').unbind(1))

func _physics_process(_delta: float) -> void:
	#TODO isso não é aq, é do movemento
	velocity.x = 0
	
	#TODO isso não é aq, é do kick
	if kick_buffering:
		if kick_buffering_duration < kick_buffering_duration_seconds:
			kick_buffering_duration += _delta
			kick.trigger(attack_direction)
		else:
			kick_buffering = false
			kick_buffering_duration = 0
	
	#TODO isso não é aq, é do grab
	if grab_buffering:
		if grab_buffering_duration < grab_buffering_duration_seconds:
			grab_buffering_duration += _delta
			grab.trigger(grab_direction)
		else:
			grab_buffering = false
			grab_buffering_duration = 0
	
	#TODO isso não é aq, é do movemento
	var movement_direction: int = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = movement_speed * movement_direction
	
	move_and_slide()
	
	#TODO isso não é aq, é da rotaçao
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
	
	#TODO isso não é aq, é do grab
	if grab.is_holding():
		grab.held_object.global_position = tongue.global_position


#TODO isso talvez seja aq, deveria ter um nó lidando com input, mas acho q é especifico de mais pra generalizar
#análise pendente
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and not grab.is_holding() and kick.can_trigger():
		var click_position: Vector2 = get_global_mouse_position()
		attack_direction = global_position.direction_to(click_position)
		kick_buffering = true
		head_animation.play("kick")
	elif event.is_action_pressed("player_special") and grab.can_trigger():
		head_animation.play("bite")
		AudioManager.play_global("player.attack")
		var click_position: Vector2 = get_global_mouse_position()
		grab_direction = global_position.direction_to(click_position)
		grab_buffering = true

func _on_death() -> void:
	# NOTE Maybe play death animation, wait a few seconds, and then actually call game_over().
	GameManager.game_over()

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	# NOTE Maybe play hurt animation, give some invincibility frames and then back to normal
	AudioManager.play_global("player.hit")
	life.damage(1)

func _on_kick_animation_animation_finished() -> void:
	head_animation.play("default")

#TODO Cristo pq isso existe e por que eu tenho medo da resposta?
func show_global():
	return global_position

#TODO isso não é aq, é do kick
func _on_kick_hit(direction, data):
	kick_buffering = false

#TODO isso não é aq, é do grab
func _on_grab_hit(direction, data):
	grab_buffering = false
