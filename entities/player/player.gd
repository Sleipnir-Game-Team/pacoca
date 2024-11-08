class_name Player
extends CharacterBody2D

@onready var kick: Kick = $Kick
@onready var grab: Grab = $Grab
@onready var life: Life = $Life
@onready var hurtbox: Area2D = $HurtBox
@onready var animation_handler: Node = $AnimationHandler

func _ready():
	animation_handler.play_animation("Tail", "tail_wigle")
	life.damage_received.connect(animation_handler.play_animation.bindv(["Body","hurt"]).unbind(1))

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
