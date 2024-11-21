extends Node2D

func _ready() -> void:
	SleipnirMaestro.load_song("level_one",true,0,false)

## Pause game when action is pressed
## TODO Uncomment
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("game_pause"):
		#get_tree().paused = true
