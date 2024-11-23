extends Power

func _effect():
	get_parent().kick.kicked.connect(_deactivate.unbind(1), CONNECT_ONE_SHOT)
	get_parent().kick.ball.heat.heat_up(6)
