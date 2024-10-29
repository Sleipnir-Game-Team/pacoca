extends MarginContainer


## Pause game when action is pressed
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("game_resume"):
		#get_tree().paused = false

func _input(event: InputEvent) -> void:
	#if GameManager._pause_layers <= 0:
	#	SfxGlobals.play_global("pause")
	#elif GameManager._pause_layers > 0:
	#	SfxGlobals.play_global("resume")
	if event.is_action_pressed("pause"):
		UI_Controller.managePauseMenu()
