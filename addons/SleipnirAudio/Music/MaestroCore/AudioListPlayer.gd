@tool
extends AudioStreamPlayer
class_name AudioListPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.volume_db = 1                 # volume pra 1
	self.pitch_scale = 1               # pitch pra 1
	self.bus = &"music"
