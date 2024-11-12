extends CharacterBody2D

class_name Player

@onready var ball: Ball = get_tree().get_first_node_in_group("Ball")

@onready var kick: Kick = $Kick
@onready var grab: Grab = $Grab
@onready var life: Life = $Life
@onready var hurtbox = $HurtBox as Area2D
@onready var animation_handler = $AnimationHandler

@onready var grabbing := false
@export var ball_cool_time := 0.5
@onready var time_until_cool := 0.0

func _ready():
	animation_handler.play_animation("Tail", "tail_wigle")
	life.damage_received.connect(animation_handler.play_animation.bindv(["Body","hurt"]).unbind(1))
	grab.thrown.connect(on_trow)
	grab.grabbed.connect(on_grab)
	kick.kicked.connect(on_kick)

func _process(delta):
	if grabbing:
		time_until_cool += delta
		if time_until_cool >= ball_cool_time:
			time_until_cool = 0
			ball.heat.cool_down()
	else:
		time_until_cool = 0 

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and not grab.is_holding():
		kick.start(global_position.direction_to(get_global_mouse_position()))
	elif event.is_action_pressed("player_special") and grab.can_trigger():
		grab.start(global_position.direction_to(get_global_mouse_position()))
		AudioManager.play_global("player.attack")

func _on_death() -> void:
	GameManager.game_over()

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	AudioManager.play_global("player.hit")
	life.damage(1)

func check_grab() -> void:
	if !grab.is_holding():
		animation_handler.play_animation("Head","idle")

func on_kick(direction) -> void:
	ball.heat.heat_up(2)

func on_grab(grabber) -> void:
	grabbing = true

func on_trow(direction) -> void:
	grabbing = false
