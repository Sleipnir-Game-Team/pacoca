extends Node

@onready var warning_sprite = $warning_sprite as Sprite2D
@onready var warning_timer = $warning_timer as Timer
@onready var warning_animation = $warning_animation as AnimationPlayer

func warning(position: Vector2):
	warning_sprite.global_position = position
	warning_animation.play("Warning")
	warning_timer.start()

func _on_warning_timer_timeout() -> void:
	warning_animation.stop()
	warning_sprite.visible = false
