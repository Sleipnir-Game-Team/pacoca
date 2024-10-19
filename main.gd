extends MarginContainer


## Pause game when action is pressed
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("game_resume"):
		#get_tree().paused = false

func _input(event):
	if event.is_action_pressed("pause"):
		UI_Controller.managePauseMenu()
