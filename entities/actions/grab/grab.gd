class_name Grab
extends AreaTrigger

var held_object: Ball = null

func _ready() -> void:
	super._ready()

func _handler(direction: Vector2, data: Dictionary) -> void:
	var ball: Ball = data.collider 
	
	if held_object != null: # THROWING
		held_object = null
		var angle_deg: float = rad_to_deg(direction.angle())
		print('ANGULO DE ARREMESSO: %sº' % angle_deg)
		ball.change_angle(angle_deg)
	else: # GRABBING
		held_object = ball

func is_holding() -> bool:
	return held_object != null
