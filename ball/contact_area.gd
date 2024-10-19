class_name ContactArea
extends Area2D

signal wall_collision(counter_clockwise)

func _ready() -> void:
	area_entered.connect(_on_Area2D_area_entered)
	body_entered.connect(_on_Area2D_Body_entered)
	
func _on_Area2D_Body_entered(body: Node2D) -> void:
	print("_on_Area2D_Body_entered")
	
	if body.is_in_group("Left Wall"):
		get_parent().flip(Vector2(-1,0))
	elif body.is_in_group("Top Wall"):
		get_parent().flip(Vector2(0,1))
	elif body.is_in_group("Right Wall"):
		get_parent().flip(Vector2(1,0))
	elif body.is_in_group("Down Wall"):
		get_parent().flip(Vector2(0,-1))
	
	
func _on_Area2D_area_entered(area):
	# Verifica se a área que entrou é a "kick"
	if area.name == "kick":
		print("Colidiu com a área 'kick'!")
