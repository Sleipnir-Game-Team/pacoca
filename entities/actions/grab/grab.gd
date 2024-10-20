class_name Grab
extends AreaTrigger

var held_object: Ball = null

func _ready() -> void:
	super._ready()

func _handler(direction: Vector2, data: Dictionary) -> void:
	var ball: Ball = data.collider 
	
	if held_object != null and (16 < ball.position.x and ball.position.x < 794): # THROWING
		held_object = null
		var angle_deg: float = rad_to_deg(direction.angle())
		ball.change_angle(angle_deg)
	else: # GRABBING
		held_object = ball

func is_holding() -> bool:
	return held_object != null
