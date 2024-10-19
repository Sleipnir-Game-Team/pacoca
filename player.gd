extends CharacterBody2D

const SPEED = 200

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_action_pressed("player_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("player_right"):
		velocity.x = SPEED
	
	if Input.is_action_pressed("player_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("player_down"):
		velocity.y = SPEED

	move_and_slide()
