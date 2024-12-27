extends Power


func active_effect():
	get_parent().ball.heat.heat_up(99999)
	print(get_parent().ball.movement.speed)

func _effect():
	get_parent().kick.kicked.connect(_deactivate.unbind(1), CONNECT_ONE_SHOT)
	get_parent().kick.kicked.connect(active_effect.unbind(1), CONNECT_ONE_SHOT)
