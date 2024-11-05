extends Node

var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini" #local:C:\Users\#USUARIO#\AppData\Roaming\Godot\app_userdata\#PROJECTNAME#
var window_mode_list = [DisplayServer.WINDOW_MODE_FULLSCREEN, DisplayServer.WINDOW_MODE_WINDOWED]

func _ready():
	verify_configfile()

func verify_configfile():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "player_up", "W")
		config.set_value("keybinding", "player_down", "S")
		config.set_value("keybinding", "player_left", "A")
		config.set_value("keybinding", "player_right", "D")
		config.set_value("keybinding", "player_hit", "mouse_0")
		config.set_value("keybinding", "player_special", "mouse_1")
		
		config.set_value("video", "window_mode", "fullscreen")
		config.set_value("video", "resolution", "1920x1080")
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		run_all_settings()

func run_all_settings():
	var video_settings = load_all_video_settings()
	change_window_mode(switch_window_mode_type(video_settings.window_mode))
	change_window_resolution(video_settings.resolution)
	
	var audio_settings = load_all_audio_settings()
	change_master_volume(min(audio_settings.master_volume, 1.0) * 100)
	change_music_volume(min(audio_settings.music_volume, 1.0) * 100)
	change_sfx_volume(min(audio_settings.sfx_volume, 1.0) * 100)


func change_window_mode(index):
	DisplayServer.window_set_mode(window_mode_list[index])
	save_video_settings("window_mode", switch_window_mode_type(index))
	
func switch_window_mode_type(value):
	match value:
		"fullscreen":
			return 0
		"windowed":
			return 1
		0:
			return "fullscreen"
		1:
			return "windowed"

func switch_window_resolution_type(value):
	if type_string((typeof(value))) == "String": value = value.to_lower()
	match value:
		"1920x1080":
			return 0
		"1600x900":
			return 1
		"1280x720":
			return 2
		0:
			return "1920x1080"
		1:
			return "1600x900"
		2:
			return "1280x720"

func change_window_resolution(resolution):
	var vector = get_vector_2i(resolution)
	DisplayServer.window_set_size(vector)
	save_video_settings("resolution", resolution)


func get_vector_2i(resolution):
	resolution = resolution.to_lower()
	var resolutions = resolution.split("x")
	var width = int(resolutions[0])
	var height = int(resolutions[1])
	return Vector2i(width, height)
	
func change_master_volume(value):
	AudioManager.change_bus_volume(&"Master", value)

func change_music_volume(value):
	AudioManager.change_bus_volume(&"music", value)

func change_sfx_volume(value):
	AudioManager.change_bus_volume(&"sfx", value)

# TODO Consertar bug que faz o botão n ser
# desmarcado quando o jogo é desmutado sem
# clicar nele (mudando o volume pelo slider)
func mute_master_volume(toggled_on):
	if toggled_on:
		AudioServer.set_bus_mute(0,true)
	else:
		AudioServer.set_bus_mute(0,false)
		

func save_video_settings(key: String, value: Variant) -> void:
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)
	

func load_all_video_settings() -> Dictionary:
	var video_settings: Dictionary = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	

func save_audio_settings(key: String, value: Variant) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	

func load_all_audio_settings() -> Dictionary:
	var audio_settings: Dictionary = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	

func get_setting(category: String, key: String) -> Variant:
	return config.get_value(category, key)
	
