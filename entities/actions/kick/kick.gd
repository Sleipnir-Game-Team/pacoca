class_name Kick
extends AreaTrigger

func _ready() -> void:
	super._ready()

func _handler(direction: Vector2, data: Dictionary) -> void:
	var ball: Ball = data.collider
	ball.change_angle(rad_to_deg(direction.angle()))
	ball.add_heat()
