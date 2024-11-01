extends Control

@onready var resolution_dropbox: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Vídeo/VBoxContainer/resolution/resolution_dropbox/resolution_dropbox
@onready var window_mode_dropbox: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Vídeo/VBoxContainer/window_mode/window_mode_dropbox/window_mode_dropbox
@onready var volume_master_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_master/volume_master_slider/volume_master_slider
@onready var volume_music_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_music/volume_music_slider/volume_music_slider
@onready var volume_sfx_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_sfx/volume_sfx_slider/volume_sfx_slider

var volume_value

func _ready(): #TODO reformular essa parada toda e colocar no ready do config_handler
	var video_settings = Config_File_Handler.load_all_video_settings()
	var window_mode
	if video_settings.window_mode == "fullscreen":
		window_mode = 0
	else:
		window_mode = 1
	window_mode_dropbox.select(int(video_settings.window_mode))
	var resolution
	if video_settings.resolution == "1920X1080":
		resolution = 0
	elif video_settings.resolution == "1600X900":
		resolution = 1
	else:
		resolution = 2
	resolution_dropbox.select(int(video_settings.resolution))
	
	var audio_settings = Config_File_Handler.load_all_audio_settings()
	volume_master_slider.value = min(audio_settings.master_volume, 1.0) * 100
	volume_music_slider.value = min(audio_settings.music_volume, 1.0) * 100
	volume_sfx_slider.value = min(audio_settings.sfx_volume, 1.0) * 100
	

func _on_window_mode_dropbox_item_selected(index):#TODO chamar uma funcao do config_handler p ele receber os valores e fzr as modificacoes
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Config_File_Handler.save_all_video_settings("window_mode", "fullscreen")
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Config_File_Handler.save_all_video_settings("window_mode", "windowed")
		2:
			pass

func _on_resolution_dropbox_item_selected(index): #TODO chamar uma funcao do config_handler p ele receber os valores e fzr as modificacoes
	var vector
	var screen_size
	match index:
		0:
			vector = Vector2i(1920, 1080)
			screen_size = "1920X1080"
		1:
			vector = Vector2i(1600, 900)
			screen_size = "1600X900"
		2:
			vector = Vector2i(1280, 720)
			screen_size = "1280X720"
	DisplayServer.window_set_size(vector)
	Config_File_Handler.save_all_video_settings("resolution", screen_size)


func _on_volume_master_slider_value_changed(value):
	AudioManager.change_bus_volume(&"Master", value) #TODO chamar uma funcao do config_handler p ele trocar o valor no jogo


func _on_volume_master_slider_drag_ended(value_changed):
	if value_changed:
		Config_File_Handler.save_all_audio_settings("master_volume", volume_master_slider.value / 100)



func _on_volume_music_slider_value_changed(value): #TODO chamar uma funcao do config_handler p ele trocar o valor no jogo
	AudioManager.change_bus_volume(&"music", value)


func _on_volume_music_slider_drag_ended(value_changed):
	if value_changed:
		Config_File_Handler.save_all_audio_settings("music_volume", volume_music_slider.value / 100)
	

func _on_volume_sfx_slider_value_changed(value): #TODO chamar uma funcao do config_handler p ele trocar o valor no jogo
	AudioManager.change_bus_volume(&"sfx", value)


func _on_volume_sfx_slider_drag_ended(value_changed): 
	if value_changed:
		Config_File_Handler.save_all_audio_settings("sfx_volume", volume_sfx_slider.value / 100)
	
	
func _on_mute_checkbox_toggled(toggled_on): #TODO chamar uma funcao do config_handler p ele receber os valores e fzr as modificacoes
	AudioManager.play_global("ui.button.click")
	Config_File_Handler.save_all_audio_settings("muted", toggled_on)
	if toggled_on:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)
		volume_value = Config_File_Handler.get_setting("audio", "master_volume")


func _on_button_pressed():
	AudioManager.play_global("ui.button.click")


func _on_back_button_pressed():
	AudioManager.play_global("ui.screen.back")
	UI_Controller.freeScreen()
