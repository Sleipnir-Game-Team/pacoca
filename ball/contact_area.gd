class_name ContactArea
extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var flip_direction: Vector2
	
	if body.is_in_group("Left Wall"):
		flip_direction = Vector2(-1, 0)
	elif body.is_in_group("Top Wall"):
		flip_direction = Vector2(0, 1)
	elif body.is_in_group("Right Wall"):
		flip_direction = Vector2(1, 0)
	elif body.is_in_group("Down Wall"):
		flip_direction = Vector2(0,-1)
	
	if flip_direction:
		get_parent().flip(flip_direction)
		
	
	
func _on_area_entered(area: Area2D) -> void:
	# Verifica se a área que entrou é a "kick"
	if area.name == "kick":
		print("Colidiu com a área 'kick'!")
