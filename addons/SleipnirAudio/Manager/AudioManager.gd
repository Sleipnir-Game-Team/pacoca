@tool
extends Node
## Gerenciador de Audio da Sleipnir (Singleton)
##
## Cuida de Tocar SFX e Música, além de garantir perfomance
## por meio de limitar número máximo de audio tocando.

var max_audiostreams : int = 256           ## Número Máximo de Sons a tocar
var sfx_playing : int                      ## Número de sons tocando
var currently_playing_audiostreams : Array ## Lista de AudioStreamPlayers tocando no momento

func _ready() -> void:
	currently_playing_audiostreams.clear() 
	# Clear dado, devido ao warning do play_sfx a lista pode acabar fechando com coisa guardada

## Método pra tocar SFX, acontando com os limites do AudioManager [br]
func play_sfx(audio_player, _max_poly: int = 4) -> void :  
	if audio_player is Array[Node]: # permite tocar grupos, pq eles são array de nodes
		for member in audio_player:
			_check_play(member)
		return
	if audio_player is SoundQueue or SoundQueue2D or AudioStreamPlayer or AudioStreamPlayer2D: # se for 
		_check_play(audio_player)
		return
	else: # se n for nenhum dos acima vai dar erro
		push_error(audio_player ," Not SoundQueue nor AudioStreamPlayer")

## Método pra parar SFX
func stop_sfx(audio_player) -> void: 
	if audio_player is Array[Node]: # permite tocar grupos, pq eles são array de nodes
		for member in audio_player:
			_check_stop(member)
		return
	if audio_player is SoundQueue or SoundQueue2D or AudioStreamPlayer or AudioStreamPlayer2D: # se for 
		_check_stop(audio_player)
		return
	else: # se n for nenhum dos acima vai dar erro
		push_error(audio_player ," Not SoundQueue nor AudioStreamPlayer")

## Método para mudar o volume dos buses de audio
func bus_volume(bus_name:String,value:float)->void:
	var bus_idx : int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_idx,value)
	
	if value <= -30:
		AudioServer.set_bus_mute(bus_idx,true)
	else:
		AudioServer.set_bus_mute(bus_idx,false)

## @experimental
## Método para criar AudioBus [br]
## feature sem uso por agora, mas que vai se fazer util no futuro
func create_bus(bus_name:String) -> Error: 
	match _check_bus_dont_exist(bus_name):
		OK:
			AudioServer.add_bus()
			AudioServer.set_bus_name(AudioServer.bus_count-1,bus_name)
			Logger.info("Added: "+bus_name+" bus")
			return OK
		var result:
			Logger.warn("Cannot create \""+bus_name+"\" bus, it already exists.")
			return ERR_ALREADY_EXISTS
		FAILED:
			return ERR_COMPILATION_FAILED
		_:
			Logger.fatal("Erro inesperado ao criar bus")
			return FAILED

## @experimental
## Método para deletar AudioBus [br]
## feature sem uso por agora, mas que vai se fazer util no futuro
func remove_bus(bus_name:String) -> Error: 
	match _check_bus_dont_exist(bus_name):
		OK:
			Logger.warn("Cannot remove \""+bus_name+"\" bus, it does not exist.")
			return ERR_DOES_NOT_EXIST
		var result:
			AudioServer.remove_bus(AudioServer.get_bus_index(result.get_string()))
			Logger.info("Removed: \""+result.get_string()+"\" bus")
			return OK
		FAILED:
			return ERR_COMPILATION_FAILED
		_:
			Logger.fatal("Erro inesperado ao remover bus")
			return FAILED


# private
func _check_play(audio_player,_max_poly: int = 4) -> void:    # O que realmente toca o sfx
	if currently_playing_audiostreams.size() <= max_audiostreams:
		# se o numero de sons tocando for menor ou igual ao numero de audiostreams maxima
		if audio_player is SoundQueue or audio_player is SoundQueue2D: # tocar o som
			audio_player.play_sound()                                
		if audio_player is AudioStreamPlayer or audio_player is AudioStreamPlayer2D: # tocar o som
			audio_player.play()
		
	if currently_playing_audiostreams.size() > max_audiostreams:
		# se passou do numero
		Logger.warn("Number of AudioStreamPlayers playing at the same time passed the maximum of "+ 
		str(max_audiostreams))
		currently_playing_audiostreams[0].stop()    # NOTE Godot 4.3 esse metodo vai mudar
		#                                           # INFO não mudou 
		currently_playing_audiostreams.remove_at(0) 
		if audio_player is SoundQueue or SoundQueue2D: # tocar o som
			audio_player.play_sound()                                
		if audio_player is AudioStreamPlayer or AudioStreamPlayer2D:
			audio_player.play()

func _check_stop(audio_player) -> void:                       # O que realmente para o sfx
	if audio_player is SoundQueue or audio_player is SoundQueue2D: # parar o som
		audio_player.stop_sound()                                
	if audio_player is AudioStreamPlayer or audio_player is AudioStreamPlayer2D: # parar o som
		audio_player.stop()

func _check_bus_dont_exist(bus_name:String)->Variant:         # Checa se o bus existe ou não
	var regex = RegEx.new()
	match regex.compile("(?i)("+bus_name+")"):
		OK:
			var result : RegExMatch
			for i in range(0,AudioServer.bus_count):
				result = regex.search(str(AudioServer.get_bus_name(i)))
				if result:
					return result
			return OK
		_:
			Logger.error("regex compiling failed, aborting operation!")
			return FAILED
