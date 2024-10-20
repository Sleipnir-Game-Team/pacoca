extends CharacterBody2D

@onready var hurt_box: Area2D = %HurtBox
@onready var life: Life = %Life

func _on_hurt_box_body_entered(body: Node2D) -> void:
	if body is Ball:
		life.damage()

func _on_life_defeat_signal() -> void:
	# NOTE Maybe play a death sound, or a death animation, then run a timer and finally actually die lmao
	queue_free()
	Waves.pop_enemy()
