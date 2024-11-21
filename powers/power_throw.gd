extends Power

func _effect():
	get_parent().kick.kicked.connect(deactivate.unbind(1), CONNECT_ONE_SHOT)
	
