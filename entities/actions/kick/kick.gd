class_name Kick
extends AreaTrigger

var attack_direction: Vector2

func _handler(direction: Vector2, data: Dictionary) -> void:
	buffering = false
	var ball: Ball = data.collider
	ball.heat.heat_up()
	ball.change_angle(rad_to_deg(direction.angle()))
