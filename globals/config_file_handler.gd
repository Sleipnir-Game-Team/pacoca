extends Node

var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "player_up", "W")
		config.set_value("keybinding", "player_down", "S")
		config.set_value("keybinding", "player_left", "A")
		config.set_value("keybinding", "player_right", "D")
		config.set_value("keybinding", "player_hit", "mouse_0")
		config.set_value("keybinding", "player_special", "mouse_1")
		
		config.set_value("video", "window_mode", "fullscreen")
		config.set_value("video", "resolution", "1920X1080")
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "music_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_all_video_settings(key: String, value: Variant) -> void:
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_all_video_settings() -> Dictionary:
	var video_settings: Dictionary = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings


func save_all_audio_settings(key: String, value: Variant) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_all_audio_settings() -> Dictionary:
	var audio_settings: Dictionary = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings

func get_setting(category: String, key: String) -> void:
	config.get_value(category, key)
