extends CharacterBody2D

class_name Player

@onready var kick: Kick = $Kick
@onready var grab: Grab = $Grab
@onready var life: Life = $Life
@onready var head_animation = $head_animation as AnimatedSprite2D
@onready var tail_animation = $tail_animation as AnimatedSprite2D
@onready var hurtbox = $HurtBox as Area2D
@onready var animation_player = $AnimationPlayer as AnimationPlayer

func _ready():
	life.damage_received.connect(animation_player.play_animation.bind('hurt').unbind(1))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_hit") and not grab.is_holding():
		kick.start(global_position.direction_to(get_global_mouse_position()))
		head_animation.play("kick")
	elif event.is_action_pressed("player_special") and grab.can_trigger():
		grab.start(global_position.direction_to(get_global_mouse_position()))
		head_animation.play("bite")
		AudioManager.play_global("player.attack")

func _on_death() -> void:
	GameManager.game_over()

func _on_hurt_box_body_entered(_body: Node2D) -> void:
	AudioManager.play_global("player.hit")
	life.damage(1)

func _on_kick_animation_animation_finished() -> void:
	head_animation.play("default")
