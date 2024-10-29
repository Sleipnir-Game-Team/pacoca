@tool
extends AudioStreamPlayer
class_name AudioInteractivePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.volume_db = -3                 # volume pra 1
	self.pitch_scale = 1               # pitch pra 1
	self.bus = &"music"
	#match AudioManager.create_bus(self.name):
	#	OK:
	#		AudioServer.set_bus_send(AudioServer.get_bus_index(self.name),"Music")
	#	_:
	#		self.bus = &"Music"

func _switch_by_bar(section_name : String ,offset : int = 0) -> void:
	await SleipnirMaestro.next_bar
	_switch_section(section_name)

func _switch_section(section_name : String):
	var playback : AudioStreamPlaybackInteractive = self.get_stream_playback()
	playback.switch_to_clip_by_name(section_name) # usa o default
	SleipnirMaestro.current_section = section_name
	
	if SleipnirMaestro.log_level <=2: 
		Logger.info(SleipnirMaestro.current_section+" ["+str(SleipnirMaestro._get_elapsed_time())+" s] [Bar "+
		str(SleipnirMaestro.elapsed_measures)+"| Beat "+str(SleipnirMaestro.elapsed_beats)+"] ")	

#func _exit_tree() -> void:
#	AudioManager.remove_bus(self.name)
