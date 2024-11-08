extends Control

@onready var resolution_dropbox: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Vídeo/VBoxContainer/resolution/resolution_dropbox/resolution_dropbox
@onready var window_mode_dropbox: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Vídeo/VBoxContainer/window_mode/window_mode_dropbox/window_mode_dropbox
@onready var volume_master_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_master/volume_master_slider/volume_master_slider
@onready var volume_music_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_music/volume_music_slider/volume_music_slider
@onready var volume_sfx_slider: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/volume_sfx/volume_sfx_slider/volume_sfx_slider
@onready var mute_checkbox: = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Áudio/audio_options/mute/mute_check/mute_checkbox
@onready var keybinding_list = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Controles/keybinding_list


func _ready():
	var window_mode = Config_Handler.get_setting("video", "window_mode")
	var resolution = Config_Handler.get_setting("video", "resolution")
	Config_Handler.update_resolution_dropbox(resolution_dropbox)
	window_mode_dropbox.select(Config_Handler.switch_window_mode_type(window_mode))
	resolution_dropbox.select(Config_Handler.switch_window_resolution_type(resolution))
	volume_master_slider.value = min(Config_Handler.get_setting("audio", "master_volume"), 1.0) * 100
	volume_music_slider.value = min(Config_Handler.get_setting("audio", "music_volume"), 1.0) * 100
	volume_sfx_slider.value = min(Config_Handler.get_setting("audio", "sfx_volume"), 1.0) * 100
	

func _on_window_mode_dropbox_item_selected(index):
	Config_Handler.change_window_mode(index)
	

func _on_resolution_dropbox_item_selected(index):
	Config_Handler.change_window_resolution(Config_Handler.switch_window_resolution_type(index))
	

func _on_volume_master_slider_value_changed(value):
	mute_checkbox.button_pressed = false
	Config_Handler.change_master_volume(value)
	

func _on_volume_master_slider_drag_ended(value_changed):
	if value_changed:
		Config_Handler.save_audio_settings("master_volume", volume_master_slider.value / 100)
	

func _on_volume_music_slider_value_changed(value):
	Config_Handler.change_music_volume(value)


func _on_volume_music_slider_drag_ended(value_changed):
	if value_changed:
		Config_Handler.save_audio_settings("music_volume", volume_music_slider.value / 100)
		

func _on_volume_sfx_slider_value_changed(value):
	Config_Handler.change_sfx_volume(value)
	

func _on_volume_sfx_slider_drag_ended(value_changed):
	if value_changed:
		Config_Handler.save_audio_settings("sfx_volume", volume_sfx_slider.value / 100)
	

func _on_mute_checkbox_toggled(toggled_on):
	AudioManager.play_global("ui.button.click")
	Config_Handler.save_audio_settings("muted", toggled_on)
	Config_Handler.mute_master_volume(toggled_on)
	

func _on_button_pressed():
	AudioManager.play_global("ui.button.click")
	

func _on_back_button_pressed():
	AudioManager.play_global("ui.screen.back")
	UI_Controller.freeScreen()
	
