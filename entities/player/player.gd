extends CharacterBody2D

@export var SPEED: int = 200

func _physics_process(delta: float) -> void:
	velocity.x = 0
	
	var direction = int(Input.is_action_pressed("player_right")) - int(Input.is_action_pressed("player_left"))
	velocity.x = SPEED * direction
	
	move_and_slide()
