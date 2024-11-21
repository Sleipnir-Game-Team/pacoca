class_name Kick
extends AreaTrigger

var attack_direction: Vector2

signal kicked(direction: float)

func _handler(direction: Vector2, data: Dictionary) -> void:
	buffering = false
	var ball: Ball = data.collider
	ball._on_kick(rad_to_deg(direction.angle()))
	kicked.emit(rad_to_deg(direction.angle()))
