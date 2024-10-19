extends Control

var volume_value : float = 100
var volume_muted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_window_mode_dropbox_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			pass

func _on_resolution_dropbox_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_back_button_pressed():
	UI_Controller.freeScreen()


func _on_volume_slider_value_changed(value):
	AudioManager.bus_volume("volume_slider", value)


func _on_mute_checkbox_toggled(toggled_on):
	AudioManager.bus_volume
