class_name ContactArea
extends Area2D

var last_contact := ""

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	if get_overlapping_bodies().size() > 0:
		var body := get_overlapping_bodies()[0]
		if !body.is_in_group(last_contact):
			_on_body_entered(body)

func _on_body_entered(body: Node2D) -> void:
	var flip_direction: Vector2
	
	if body.is_in_group("Left Wall"):
		last_contact = "Left Wall"
		flip_direction = Vector2(-1, 0)
	elif body.is_in_group("Top Wall"):
		last_contact = "Top Wall"
		flip_direction = Vector2(0, 1)
	elif body.is_in_group("Right Wall"):
		last_contact = "Right Wall"
		flip_direction = Vector2(1, 0)
	elif body.is_in_group("Down Wall"):
		last_contact = "Down Wall"
		flip_direction = Vector2(0,-1)
	
	if flip_direction:
		get_parent().flip(flip_direction)
		


func _on_area_entered(area: Area2D) -> void:
	# Verifica se a área que entrou é a "kick"
	if area.name == "kick":
		print("Colidiu com a área 'kick'!")
