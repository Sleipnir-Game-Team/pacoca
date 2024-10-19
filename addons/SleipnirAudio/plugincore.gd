@tool
extends EditorPlugin

const MAESTRO_SINGLETON      = "SleipnirMaestro"
const AUDIOMANAGER_SINGLETON = "AudioManager"
const SFXGLOBALS_SINGLETON   = "SfxGlobals"

func _enter_tree() -> void:
	add_custom_type("SoundQueue", "Node",
	preload("SFX/SoundQueue.gd"),preload("res://assets/Icons/soundqueue.png"))
	
	add_custom_type("SoundQueue2D", "Node2D",
	preload("SFX/SoundQueue2D.gd"),preload("res://assets/Icons/soundqueue2d.png"))
	
	add_autoload_singleton(SFXGLOBALS_SINGLETON,"SFX/SFXGlobals.tscn")
	add_autoload_singleton(AUDIOMANAGER_SINGLETON,"Manager/AudioManager.gd")
		
	add_custom_type("SongData","Resource",
	preload("Music/MaestroCore/SongData.gd"),preload("res://assets/Icons/song_data.png"))

	add_custom_type("AudioInteractivePlayer","AudioStreamPlayer",
	preload("Music/MaestroCore/AudioInteractivePlayer.gd"),preload("res://assets/Icons/AudioPlayerInteractive.svg"))

	add_custom_type("AudioSyncPlayer","AudioStreamPlayer",
	preload("Music/MaestroCore/AudioSyncPlayer.gd"),preload("res://assets/Icons/AudioPlayerInteractive.svg"))
	
	add_custom_type("AudioListPlayer","AudioStreamPlayer",
	preload("Music/MaestroCore/AudioListPlayer.gd"),preload("res://assets/Icons/AudioPlayerList.svg"))
	
	add_autoload_singleton(MAESTRO_SINGLETON,"Music/SleipnirMaestro.tscn")

func _exit_tree() -> void:
	remove_custom_type("SoundQueue")
	remove_custom_type("SoundQueue2D")
	remove_autoload_singleton(AUDIOMANAGER_SINGLETON)
	remove_autoload_singleton(SFXGLOBALS_SINGLETON)
	remove_custom_type("SongData")
	remove_autoload_singleton(MAESTRO_SINGLETON)
