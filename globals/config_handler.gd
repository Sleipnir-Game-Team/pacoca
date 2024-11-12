extends Node

var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini" #local:C:\Users\#USUARIO#\AppData\Roaming\Godot\app_userdata\#PROJECTNAME#
var window_mode_dict = {3 : DisplayServer.WINDOW_MODE_FULLSCREEN, 0 : DisplayServer.WINDOW_MODE_WINDOWED}
@onready var keybinding_list = $CanvasLayer/MarginContainer/VBoxContainer/TabContainer/Controles/keybinding_list
var resolution = DisplayServer.screen_get_size()
var pc_resolution = [resolution[0], resolution[1]]
var pc_width = pc_resolution[0]
var pc_height = pc_resolution[1]
signal window_mode_changed
signal window_resolution_changed

func _ready():
	verify_configfile()

######################################### Init Handler #########################################
func verify_configfile():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "player_up", "W")
		config.set_value("keybinding", "player_down", "S")
		config.set_value("keybinding", "player_left", "A")
		config.set_value("keybinding", "player_right", "D")
		config.set_value("keybinding", "player_hit", "mouse_0")
		config.set_value("keybinding", "player_special", "mouse_1")
		
		config.set_value("video", "window_mode", 3)
		config.set_value("video", "width", pc_width)
		config.set_value("video", "height", pc_height)
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		verify_all_settings()
		run_all_settings()

func run_all_settings():
	var video_settings = load_all_video_settings()
	change_window_settings(video_settings.window_mode, [video_settings.width, video_settings.height])
	
	var audio_settings = load_all_audio_settings()
	change_master_volume(min(audio_settings.master_volume, 1.0) * 100)
	change_music_volume(min(audio_settings.music_volume, 1.0) * 100)
	change_sfx_volume(min(audio_settings.sfx_volume, 1.0) * 100)

func verify_all_settings():
	if get_setting("video", "resolution") != null:
		save_video_settings("resolution", null)
	if get_setting("video", "width") == null:
		save_video_settings("width", pc_width)
	if get_setting("video", "height") == null:
		save_video_settings("height", pc_height)
	if type_string(typeof(get_setting("video", "window_mode"))) == "String":
		save_video_settings("window_mode", 3)
	if get_setting("video", "supported_resolutions") != null:
		save_video_settings("supported_resolutions", null)


######################################### Window Handler #########################################
func change_window_mode(mode):
	DisplayServer.window_set_mode(mode)
	save_video_settings("window_mode", mode)
	

func change_window_resolution(resolution):
	var vector = Vector2i(resolution[0], resolution[1])
	var decoration_size = Vector2i(DisplayServer.window_get_size_with_decorations() - DisplayServer.window_get_size())
	vector -= decoration_size
	var pos = [pc_resolution[0]/2 - vector[0]/2, pc_resolution[1]/2 - vector[1]/2]
	DisplayServer.window_set_size(vector)
	DisplayServer.window_set_position(Vector2i(pos[0], pos[1]))
	save_video_settings("width", resolution[0])
	save_video_settings("height", resolution[1])

func change_window_settings(window_mode, window_resolution):
	if window_mode != null and window_resolution != null:
		var borderless = (window_mode >= 3)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, borderless)
		change_window_mode(window_mode)
		change_window_resolution(window_resolution)
		window_mode_changed.emit(window_mode)
		window_resolution_changed.emit(window_resolution)
	elif window_mode != null and window_resolution == null:
		if window_mode >= 3:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			change_window_mode(window_mode)
			change_window_resolution(pc_resolution)
			window_mode_changed.emit(window_mode)
			window_resolution_changed.emit(pc_resolution)
		else:
			var resolution = [get_setting("video", "width"), get_setting("video", "height")]
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			change_window_mode(window_mode)
			change_window_resolution(resolution)
			window_mode_changed.emit(window_mode)
			window_resolution_changed.emit(resolution)
	elif window_mode == null and window_resolution != null:
		if window_resolution != pc_resolution:
			if DisplayServer.window_get_mode() != 0:
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
				change_window_mode(0)
				window_mode_changed.emit(0)
			change_window_resolution(window_resolution)
			window_resolution_changed.emit(window_resolution)
	else:
		Logger.fatal("Erro: Configuração selecionada não existe")
#ordem:
#1 flag
#2 mode
#3 resolution

######################################### Volume Handler #########################################
func change_master_volume(value):
	AudioManager.change_bus_volume(&"Master", value)


func change_music_volume(value):
	AudioManager.change_bus_volume(&"music", value)


func change_sfx_volume(value):
	AudioManager.change_bus_volume(&"sfx", value)


func mute_master_volume(toggled_on):
	if toggled_on:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)
		

######################################### Input Handler #########################################
func create_action_list():
	InputMap.load_from_project_settings()
	for item in keybinding_list:
		item.queue_free()
		
	var action_formatted_list = format_actions(InputMap.get_actions())
	for action in action_formatted_list:
		#var button = input_button_scene.instantiate()
		pass


func format_actions(actions):
	pass


######################################### Saving Handler #########################################
func save_video_settings(key: String, value: Variant) -> void:
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)
	

func save_audio_settings(key: String, value: Variant) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


######################################### Loading Handler #########################################
func load_all_video_settings() -> Dictionary:
	var video_settings: Dictionary = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	

func load_all_audio_settings() -> Dictionary:
	var audio_settings: Dictionary = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	

func get_setting(category: String, key: String) -> Variant:
	return config.get_value(category, key)
	
