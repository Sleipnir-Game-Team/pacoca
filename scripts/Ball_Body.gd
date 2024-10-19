extends CharacterBody2D


var velocidade = 400
var direction: Vector2 = Vector2(200, 150).normalized() * velocidade


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide(direction * delta)
	
	if collision_info:
		print("Colidiu com:", collision_info.get_collider().name)  
		direction = direction.bounce(collision_info.get_normal())
