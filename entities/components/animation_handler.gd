extends AnimationPlayer


func play_animation(animation_name):
	play(animation_name)
	
func stop_named_animation(animation_name):
	if(current_animation == animation_name):
		stop()
	
func stop_animation():
	stop()
