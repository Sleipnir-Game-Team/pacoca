@tool
## Sleipnir Global Music Player
##
## [b][color=crimson]ATENÇÃO[/color] Measure e Bar são a mesma coisa. 
## estes termos são usados alternadamente durante esse código[/b] [br] [br]
## Para usar, salve sua musica como [SongData] e defina o path de onde você irá guardar estes resources. [br]
## Esses resources serão então carregados no SleipnirMaestro 
## onde todos os dados são tratados, e adicionados dinamicamente a nodes para poder tocar e
## transicionar as músicas e suas diversas sessões. [br]
extends Node

# sinais de tempo
signal beat (position:int)              ## manda a beat atual 
signal measure (position:int)           ## manda a measure atual
signal next_bar                         ## manda a próxima measure 
signal next_beat                        ## manda a próxima beat 

# variáveis do editor
@export_category("Config Geral")        # Configurações relacionadas a música
@export var MainPlayer     : Node       ## [Node] que cuida dos clips principais
@export var TriggerPlayer  : Node       ## [Node]  que cuida dos clips de trigger
@export var Clock          : Timer      ## Clock para contar tempo musical 
@export_dir var _song_path : String     ## Path das músicas
@export_subgroup("Debug")               # Configurações de debugging
@export_enum(                           # enum de logging
"ALL","DEBUG","INFO","WARN","ERROR","FATAL","OFF"
) var log_level : int = 2               ## Selecionar nível de logging

# variaveis de tempo
var BPM              : int              ## Beats per Minute
var BeatsPerBar      : int              ## Beat em 1 até infty (só n abusa)
var SPB              : float            ## Seconds Per Beat
# variaveis de monitoramento
var elapsed_measures : int = 0:         ## conta as barras
	set(value):
		elapsed_measures = value
		if value == _next_measure:
			next_bar.emit()
	get:
		return elapsed_measures
var elapsed_beats    : int = 1:         ## conta beats sempre relativo a Time Signature
	set(value):
		elapsed_beats = value
		if value == _next_beat:
			next_beat.emit()
	get:
		return elapsed_beats       
var current_section  : String           ## em que sessão estamos?
var current_song     : String = "none"  ## musica atual
var sync_streams     : Dictionary       ## streams de sync atuais [br](no momento somente válidas para [AudioStreamSynchronized] como MainClip)

#region variaveis privadas
var _next_measure              : int:               # próxima measure
	set(value):
		_next_measure = elapsed_measures+1
var _next_beat                 : int:               # próxima beat
	set(value):
		_next_beat = elapsed_beats+1 if elapsed_beats < BeatsPerBar else 1
var _section_dict              : Dictionary         # sessões da música mapeadas para int
var _current_song_node         : AudioStreamPlayer  # Node da música atual mais nova
var _trigger_stems             : Array              # stems trigger
var _currently_playing_trigger : Array              # triggers tocando
var _transition_type           : int                # qual transição vai rolar
var _corrected_transitions     : Array              # as transições corrigidas do modo BAR de transição
var _is_changing_songs         : bool = false       # se está mudando de música
var _silence_path : String = "res://Systems/SleipnirMaestro/silence-500ms.mp3"  # path do placeholder de silencio
#endregion

# funções públicas VVVVVVVVV
#region PlayBack

## da o play, com ou sem fade in
## [codeblock]SleipnirMaestro.play()[/codeblock]
func play(fade:bool=false,fade_time:float=1.0) ->void:
	if current_song == "none":        # se não tem musica carregada retorna
		Logger.warn("there's no song here!")
		return
	if (_current_song_node.is_playing() == true): # se já estiver tocando retorna
		Logger.warn("song already playing!")
		return
		
	Clock.start()     # começa o conductor
	_next_beat = _next_beat
	_next_measure = _next_measure
	if fade == false:
		_current_song_node.set_volume_db(0.0)
		_current_song_node.play() # da play
	else:
		_current_song_node.set_volume_db(-60.0)
		var fader = create_tween()
		_current_song_node.play() # da play
		fader.tween_method(_current_song_node.set_volume_db,-60,0,(fade_time))

## para tudo, com ou sem fade out
## [codeblock]SleipnirMaestro.stop()[/codeblock]
func stop(fade:bool=false,fade_time:float=1.0) ->void : 
	if current_song == null or _current_song_node == null: # se não tiver musica, retorna
		Logger.warn("there's no song here!")
		return
	
	if _current_song_node.is_playing() == false: # se já nao estiver tocando, retorna
		Logger.warn("The Song is not playing! can't stop what's not happening")
		return
	
	if fade == false:
		_current_song_node.stop() # para musica
	else:
		var fader = create_tween()
		fader.tween_method(_current_song_node.set_volume_db,0,-60,(fade_time))
		fader.tween_callback(_current_song_node.stop)
	
	Clock.stop()      # para clock
	elapsed_beats    = 1
	elapsed_measures = 0
	current_section = _section_dict.keys()[0] if _current_song_node is AudioInteractivePlayer else "null"
	
	if _currently_playing_trigger.size() != 0: # para os triggers
		for TriggerStem in _currently_playing_trigger:
			TriggerStem.stop()
			_currently_playing_trigger.erase(TriggerStem)

## chama um clip e da play nele
## [codeblock]
## # pode ser
## SleipnirMaestro.trigger("nome_do_trigger")
## # ou
## SleipnirMaestro.trigger("nome_do_trigger",int)
## # esta int podendo ser 0 ou 1 ,onde 0 é por beat e 1 é por bar
## [/codeblock]    
func trigger(trigger_name:String,sync_method:int=0) ->void :
	if current_song == "none":     # se não tem musica carregada retorna
		if log_level <=3: Logger.warn("there's no song here!")
		return
		
	if (_current_song_node.is_playing() == false): # se não estiver tocando retorna
		Logger.warn("can't play when song is not playing")
		return
	
	if _trigger_stems.has(trigger_name) == false: # se não tem o trigger chamado
		if log_level <=3: Logger.warn("there's no trigger with the name \""+trigger_name+"\"")
		return

	var TriggerStem = get_node("/root/SleipnirMaestro/Triggers/"+trigger_name)
	
	_trigger_play(TriggerStem,sync_method) ## WARNING TESTAR BEM.
	
	_currently_playing_trigger.append(TriggerStem)
	
	await TriggerStem.finished
	
	if log_level <=1: Logger.debug("finished playing: "+TriggerStem.name)
	
	_currently_playing_trigger.erase(TriggerStem)

## pausa tudo
## [codeblock]SleipnirMaestro.pause()[/codeblock]
func pause() ->void :
	if current_song == "none": #se não tem musica tocando retorna
		Logger.warn("there's no song here!")
		return 
	if _current_song_node.get_stream_paused() == true: # se não estiver pausado, retorna
		Logger.warn("song already paused!")
		return
	_current_song_node.stream_paused = true # pausa musica
	Clock.set_paused(true) # pausa clock
	Logger.info("Paused!")
	if _currently_playing_trigger.size() != 0: # pausa trigger 
		for TriggerStem in _currently_playing_trigger:
			TriggerStem.set_stream_paused(true)

## resume o pause
## [codeblock]SleipnirMaestro.resume()[/codeblock]
func resume() ->void :
	if current_song == "none": # se não tem musica tocando, retorna
		Logger.warn("there's no song here!")
		return 
	if _current_song_node.get_stream_paused() == false: # se não estiver pausado, retorna
		Logger.warn("song already playing!")
		return
	Clock.set_paused(false) # resume clock
	_current_song_node.stream_paused = false # resume musica
	Logger.info("Resumed!")
	if _currently_playing_trigger.size() != 0:
		for TriggerStem in _currently_playing_trigger:
			
			TriggerStem.set_stream_paused(false)
#endregion

## Muda de música de acordo com suas especificações [br]
## [codeblock]
## # pode ser
## SleipnirMaestro.change_song("nome_da_musica")
## # ou também
## SleipnirMaestro.change_song("nome_da_musica",stay_playing:bool,transition_type:String, keep_section:bool)
## [/codeblock]
## onde: [br]
## [param stay_playing] diz se continua tocando enquanto transiciona ou não[br]
## [param transition_type] pode ser "FADE","REVERB" ou "CUT" [br]
## [param keep_section] diz se mantém a sessão anterior, ou se muda pra default, por exemplo, se estava em combate, se deve permanecer quando transicionar ou não
## 
func change_song(song_name:String, stay_playing:bool=false, transition_type:String="FADE", keep_section:bool=false) ->Error:
	# BUG se tu trocar várias vezes muito rápido (o que é BEM improvável), cria audiostream extra. 
	# ele eventualmente é limpado, mas acaba gerando duas transições por algum motivo
	
	if _current_song_node != null and song_name == _current_song_node.name: # checa se n tá tentando ir pra mesma
		if log_level <= 3: Logger.warn("Cannot change to the same song!")
		return ERR_ALREADY_IN_USE
	
	_is_changing_songs = true
	if Clock.is_stopped() == false: # se o clock não está parado, para
		Clock.stop() 
	if TriggerPlayer.get_child_count() != 0: # se tiver trigger, tira
		# TODO tem que ter algo aqui que garanta ela não tocar, ou nao remover até o trigger terminar de tocar
		_trigger_remove()
		_trigger_stems.clear()
		
	
	sync_streams.clear()
	_corrected_transitions.clear()
	_section_dict.clear()
	
	var old_song : AudioStreamPlayer
	
	if (_current_song_node != null) and (song_name != str(_current_song_node.name)):
		if log_level<=2: Logger.info("Transitioning from "+str(_current_song_node.name)+" to "+current_song)
		old_song = _current_song_node
	
	# carrega o resource da musica
	var song_data = load(_song_path+"/"+song_name+".tres")
	
	print("SleipnirMaestro, ", str(song_data.resource_name))
	
	if song_data == null or song_data is not SongData:
		Logger.error("Could not load song \""+song_name+"\"")
		return ERR_FILE_NOT_FOUND
	
	if MainPlayer.get_child_count() == 0:
		_data_handling(song_data) # distribui os dados onde precisa
	else:
		_data_handling(song_data,keep_section) # distribui os dados onde precisa
		
	elapsed_measures = elapsed_measures # seta as measures
	current_song = song_name
	
	# mensagens extras
	var _stay_playing_message :String = " "
	var _keep_section_message :String = " "

	if old_song == null:
		if log_level < 3: 
			Logger.info(str(current_song)+" Ready! at "+
			str(BPM)+" BPM or "+ str(SPB) +" SPB | "+str(BeatsPerBar)+" Beats per Bar")
		
		_is_changing_songs = false
		return OK
	
	if stay_playing == true: _stay_playing_message = "| continued playing" 
	else: _stay_playing_message = "| stopped playing"
	
	if _current_song_node.stream is AudioStreamInteractive:
		_keep_section_message = "| keeping section "+current_section if keep_section == true else "| overriding section to default"
	
	if stay_playing == true and old_song.is_playing():
		match transition_type:
			"FADE":
				_clock_reset()
				_current_song_node.play()
				_fade_transition(old_song,_current_song_node)
			"CUT":
				old_song.stop()
				_clock_reset()
				_current_song_node.play()
				old_song.queue_free()
			_:
				if log_level <= 3: Logger.warn("Invalid Transition type, using FADE")
				_clock_reset()
				_current_song_node.play()
				_fade_transition(old_song,_current_song_node)
	else:
		old_song.queue_free()
	
	_is_changing_songs = false
	
	if log_level < 3: 
		Logger.info(str(current_song)+" Ready! at "+
		str(BPM)+" BPM or "+ str(SPB) +" SPB "+_stay_playing_message+" "+_keep_section_message)

	return OK

## Muda de sessão para a música toda [br]
## [codeblock]SleipnirMaestro.switch_song_section("combat")[/codeblock]
func switch_song_section(section_name:String,offset:int=0) ->Error:
	if _current_song_node.stream is not AudioStreamInteractive:
		if log_level<=3:
			Logger.warn("stream invalid: "+str(_current_song_node.stream)+" Can only use this method if Main Stream is of type AudioStreamInteractive")
		return ERR_INVALID_PARAMETER

	# se quiser mudar pra sessão atual, retorna
	if current_section == section_name:
		Logger.warn("can't switch to the same section")
		return ERR_ALREADY_IN_USE
	
	# se não tiver musica, retorna
	if current_song == "none": 
		push_error("there's no song here!")
		return ERR_UNAVAILABLE
	
	# se estiver pausado ou parado, retorna
	if (_current_song_node.is_playing() == false) and (_current_song_node.get_stream_paused() == false):
		Logger.warn("can't switch to section when stopped or paused!")
		return ERR_UNAVAILABLE
	
	#if log_level <=1 : 
	#	Logger.debug("transition type é: "
	#	+str(_current_song_node.stream.get_transition_from_time(_section_dict[current_section],_section_dict[section_name])))
	
	if _corrected_transitions.has([_section_dict[current_section],_section_dict[section_name]]):
		if log_level <=2 : Logger.info("will switch to "+ section_name +" ["+str(_get_elapsed_time())+" s]") 
		_current_song_node._switch_by_bar(section_name,offset)
		return OK
		
	# se deu tudo certo, checa o tipo de transição
	match _transition_type: 
		2: # se for por bar
			if log_level <=2 : Logger.info("will switch to "+ section_name +" ["+str(_get_elapsed_time())+" s]") 
			_current_song_node._switch_by_bar(section_name,offset) # usar o método custom de transição
		_: # se for qualquer outra
			_current_song_node._switch_section(section_name)
	return OK

## Ativa Layer
## [codeblock]SleipnirMaestro.toggle_layer_on(0)[/codeblock]
func toggle_layer_on(SyncStream:int) ->Error:
	if sync_streams.is_empty():
		if log_level <= 3: Logger.warn("No sync_streams for this player")
		return ERR_DOES_NOT_EXIST
	
	if sync_streams[SyncStream] == true:
		if log_level <=1: Logger.debug("Layer Already Active!")
		return ERR_ALREADY_IN_USE
	
	if _current_song_node.get_stream() is not AudioStreamSynchronized:
		if log_level <= 3 : Logger.warn("can't toggle unless is AudioStreamSynchronized")
		return ERR_INVALID_PARAMETER
	
	_current_song_node._toggle_layer_on(SyncStream)
	
	return OK

## Desativa Layer
## [codeblock]SleipnirMaestro.toggle_layer_off(0)[/codeblock]
func toggle_layer_off(SyncStream:int) -> Error:
	if sync_streams.is_empty():
		if log_level <= 3: Logger.warn("No sync_streams for this player")
		return ERR_DOES_NOT_EXIST
	
	if sync_streams[SyncStream] == false:
		if log_level <=1: Logger.debug("Layer Already Deactivated!")
		return ERR_ALREADY_IN_USE
	
	var MainStream : Variant = _current_song_node.get_stream()
	if MainStream is not AudioStreamSynchronized:
		if log_level <= 3 : Logger.warn("can't toggle unless is AudioStreamSynchronized")
		return ERR_INVALID_PARAMETER
	
	_current_song_node._toggle_layer_off(SyncStream)
	return OK

# funções privadas 
func _ready() -> void:
	if Clock.one_shot != false: # só pra garantir o clock n tocar só uma vez
		Clock.one_shot = false
	#var _measure_tracker = Callable(self,"_measure_tracker")
	if TriggerPlayer.get_child_count() != 0: # se tiver algum trigger aqui, remover
		_trigger_remove()                

# o que acontece quando o conductor conta 1 Beat
func _on_conductor_timeout() -> void:
	elapsed_beats += 1                            # Adiciona ao elapsed_beats
	_next_beat = _next_beat
	if elapsed_beats == BeatsPerBar+1:            # Checa se não finalizou uma Measure
		elapsed_beats = 1                         # Reseta o timer de beats
		emit_signal("measure", elapsed_measures)  # Emite sinal de finalizar Measure
		elapsed_measures += 1                     # Adiciona ao elapsed_measures
		_next_measure = _next_measure
	
	if log_level < 2:                             # Log informando tempo musical
		Logger.debug(str(elapsed_measures)+"Bar "
		+str(elapsed_beats)+"Beat "
		+"["+str(_get_elapsed_time())+" s]")
	
	emit_signal("beat", elapsed_beats)            # Emite o sinal de finalizar uma Beat	

# só a transição por fade
func _fade_transition(old:AudioStreamPlayer,new:AudioStreamPlayer) ->void:
	new.volume_db = -60
	var fader = create_tween()
	fader.tween_method(new.set_volume_db,-60,0,(SPB*BeatsPerBar))
	fader.parallel().tween_method(old.set_volume_db,0,-60,(SPB*BeatsPerBar))
	fader.tween_callback(old.queue_free)	

#region Utilities
# literal só pega o tempo atual da engine
func _get_elapsed_time() -> float: return Time.get_ticks_msec()/1000.00;

# reseta o clock quando muda de musica
func _clock_reset()->void:
	elapsed_beats = 1
	elapsed_measures = 0
	Clock.start()
#endregion

# aviso funções gigante abaixo
#region Data Handling
# função para pegar os dados e popular o player Main e os Triggers
func _data_handling(song_data:Resource,change_to_default_first:bool=true) -> void:
	var is_silent : bool = false
	var AudioPlayer : AudioStreamPlayer
	
	if song_data.MainClips is AudioStreamInteractive:
		AudioPlayer = AudioInteractivePlayer.new()
		_interactive_setup(song_data,AudioPlayer,change_to_default_first)
		AudioPlayer.name = song_data.resource_path.get_file().get_basename()
		
	elif song_data.MainClips is AudioStreamSynchronized:
		AudioPlayer = AudioSyncPlayer.new()
		var clips = song_data.get_main_clips()
		AudioPlayer.set_stream(clips)           # seta a stream pro MainPlayer
		AudioPlayer.name = song_data.resource_path.get_file().get_basename()
		
	elif song_data.MainClips is AudioStreamPlaylist: 
		AudioPlayer = AudioListPlayer.new()
		AudioPlayer.set_stream(song_data.get_main_clips())           # seta a stream pro MainPlayer
		AudioPlayer.name = song_data.resource_path.get_file().get_basename()
	
	else:
		AudioPlayer = AudioStreamPlayer.new()
		Logger.error("Invalid AudioStream, loading silence stream...")
		is_silent = true
		AudioPlayer.set_stream(_load_mp3())
		AudioPlayer.name = "NO_AUDIO"
		AudioPlayer.bus = &"music"
	
	MainPlayer.add_child(AudioPlayer)      # adiciona o node ao player
	_current_song_node = AudioPlayer
	
	if is_silent == false: _get_bpm(song_data)                               # seta o BPM pro clock só se não for silencio
	
	if song_data.has_trigger_clips == true:      # se tem trigger
		var trigger_clips : Array = song_data.get_trigger_clips() # seta a stream pro trigger
		_trigger_populate(trigger_clips)
	else: return                 # se não tem , retorna

# pega o BPM para usar no clock
# usado no _data_handling()
func _get_bpm(song_data:Resource) -> void: 
	if song_data.BPM != 0: # vê se os dados estão sendo dados no resource
		BPM = song_data.BPM                                      # pega o BPM dela
		BeatsPerBar = song_data.BeatsPerBar                      # pega as BeatsPerBar dela
		SPB = 60.0/(BPM*(BeatsPerBar/4))                         # calcula SPB
		Clock.wait_time = SPB                                    # Seta o conductor para o tempo certo
		return	
	# TODO falta uma forma de pegar bpm caso alguem esqueça do bpm
	elif log_level<=4: 
			Logger.warn("No BPM found in "+str(song_data.resource_path.get_file().get_basename())+".tres, sync errors may occur")

func _load_mp3() -> AudioStreamMP3: 
	var file = FileAccess.open(_silence_path, FileAccess.READ)
	# pega um arquivo em silencio
	var sound = AudioStreamMP3.new()
	# cria um AudioStreamMP3 Novo
	sound.data = file.get_buffer(file.get_length())
	# Esqueci
	return sound 
	# retorna a audiostream
#endregion

#region Trigger Handling
# função que remove trigger
# ATTENTION PELAMOR DE DEUS VERIFICAR SE O CODIGO COMENTADO TÁ CERTO
func _trigger_remove():
	for trigger_stem in TriggerPlayer.get_children(): # literal só remove e queue_free diretão
		if trigger_stem.is_playing(): # se a stem ainda tiver tocando, dá um fadezao
			var fader = create_tween()
			fader.tween_method(trigger_stem.set_volume_db,-60,0,(SPB*BeatsPerBar))
			fader.tween_callback(TriggerPlayer.remove_child.bind(trigger_stem))
			fader.tween_callback(trigger_stem.queue_free)
			continue
		TriggerPlayer.remove_child(trigger_stem)
		trigger_stem.queue_free()

# função que cria trigger
func _trigger_populate(triggers:Array): 
	for i in range(0,triggers.size()):    # cria audiostreams pra cada clip de trigger
		var trigger_node = AudioStreamPlayer.new() # cria audiostreamplayer
		trigger_node.volume_db = 1
		trigger_node.pitch_scale = 1              
		trigger_node.bus = &"music"
		# setup do node
		trigger_node.set_stream(triggers[i])       # seta a stream dele pro clip de trigger
		trigger_node.name = triggers[i].resource_path.get_file().get_basename()  # seta o nome do node pro nome do clip
		# append no maestro
		_trigger_stems.append(trigger_node.name)   # dá append na var das stems
		TriggerPlayer.add_child(trigger_node)      # adiciona o node ao player
	
	if log_level <=2 and _trigger_stems.size() > 0: 
		Logger.info("Trigger Loaded = "+str(_trigger_stems.size()))
		Logger.info("Loaded Triggers = "+str(_trigger_stems))
	elif log_level <=2 and _trigger_stems.size() == 0:
		Logger.info("This Song Doesn't Have Any Trigger Stems")

# método pra tocar trigger syncado
func _trigger_play(TriggerStem,sync_method:int=0) -> Error:
	if _is_changing_songs == true: # se estiver trocando de música
		if log_level <=2: Logger.info("Ignoring trigger play for "+TriggerStem.name+", because we're changing songs")
		return ERR_UNAUTHORIZED
	
	match sync_method:
		0: ## por beat
			await next_beat
			if !is_instance_valid(TriggerStem): return ERR_UNAUTHORIZED
			
			TriggerStem.play() # da play
			if log_level <=2: Logger.info("playing: "+TriggerStem.name+" ["+str(_get_elapsed_time())+"]")
			
		1: ## por bar
			await next_bar
			if !is_instance_valid(TriggerStem): return ERR_UNAUTHORIZED
			
			TriggerStem.play() # da play
			if log_level <=2: Logger.info("playing: "+TriggerStem.name+" ["+str(_get_elapsed_time())+"]")
			
		_: ## fora da seleção
			if log_level <= 3: Logger.warn("Invalid sync method for playing trigger, using next beat")
			await next_beat
			if !is_instance_valid(TriggerStem): return ERR_UNAUTHORIZED
			
			TriggerStem.play() # da play
			if log_level <=2: Logger.info("playing: "+TriggerStem.name+" ["+str(_get_elapsed_time())+"]")
	return OK
#endregion

# Aqui tem as que mão uso mais, mas pode ser que eu use depois
#region deprecated
func _look_for_bpm():
	# qual é a primeira stream do node
	var first_stream : Variant = _current_song_node.stream    
	var reference_stream : Variant      # variável que vai ser usada para pegar bpm
	var count : int                     # variavel pra loop pra achar bpm
	var stream_get : Callable           # qual método vai pegar
	
	if _current_song_node.stream is AudioStreamInteractive:
		count = first_stream.clip_count
		stream_get = Callable(AudioStreamInteractive,"get_clip_streams")
	elif _current_song_node.stream is AudioStreamSynchronized:
		count = first_stream.stream_count       
		stream_get = Callable(AudioStreamSynchronized,"get_sync_streams")
	elif _current_song_node.stream is AudioStreamPlaylist:
		count = first_stream.stream_count
		stream_get = Callable(AudioStreamPlaylist,"get_list_streams")
		
	for index_stream in range(0,count):
		var stream : Variant # stream a ser analisada
		stream = first_stream.stream_get.bind(index_stream)
		if (
			stream is AudioStreamInteractive or
			stream is AudioStreamSynchronized or 
			stream is AudioStreamPlaylist or 
			stream.is_meta_stream()
			):
			stream = _get_child_stream(stream)
		
		if stream.get_bpm() == 0:
			continue
			
		reference_stream = stream
		break

	BPM = int(reference_stream.get_bpm())                    # pega o BPM dela
	BeatsPerBar = int(reference_stream.get_bar_beats())      # pega as BeatsPerBar dela
	SPB = 60.0/(BPM*(BeatsPerBar/4))                         # calcula SPB
	Clock.wait_time = SPB                                    # Seta o conductor para o tempo certo

# pega a AudioStreamMP3, OggVorbis ou WAV
# usado no _get_bpm()
func _get_child_stream(stream): 
	## Aqui é a mais pura bagunça, desculpa o textão mas puta que pariu.
	## tem um método diferente pra cada uma das 3 AudioStreams Musicais
	## essa função inteira é só lidando com o método de cada uma delas
	
	var count : int # variavel que conta quantas streams tem 
	
	if stream is not AudioStreamInteractive: # se não for interactive, usa a propriedade comum
		count = stream.stream_count # quantos clips tem
	else: # se for, USA A PORRA DA PROPRIEDADE ESPECIFICO PARA INTERACTIVE
		count = stream.clip_count
		
	for i in range(0,count):  # loopa dentro do count
		var audiostream # definimos um audiostream, que pode ser qualquer um
		if stream is AudioStreamSynchronized: # se for sync, usa metodo do sync
			audiostream = stream.get_sync_stream(i)
		elif stream is AudioStreamInteractive:# se for interactive, usa metodo do interactive
			audiostream = stream.get_clip_stream(i)
		elif stream is AudioStreamPlaylist:   # se for playlist, usa metodo do playlist
			audiostream = stream.get_list_stream(i)
		else:
			if log_level <=3 : Logger.warn("audiostream is not meta_stream")
		
		# checa se o resultado n foi um dos tipos de audiostreams formados de outro
		# se for, repete a função
		if (
		audiostream is AudioStreamInteractive or 
		audiostream is AudioStreamPlaylist or 
		audiostream is AudioStreamSynchronized or 
		audiostream.is_meta_stream()
		):
				_get_child_stream(audiostream)
		# se não, só retorna o audiostream
		elif ( 
		audiostream is AudioStreamMP3 or 
		audiostream is AudioStreamOggVorbis or 
		audiostream is AudioStreamWAV
		):
			return audiostream
		# se n for nenhum deles, deu merda
		else:
			if log_level <=4 :Logger.error("No Usable AudioStreams found")
#endregion

func _interactive_setup(song_data:Resource,AudioPlayer:AudioStreamPlayer,change_to_default_first:bool)->void:
	_section_dict = song_data.get_sections()
	Logger.info("Sections are: "+str(_section_dict))
	if change_to_default_first == true:
		current_section = song_data.get_first_section()          # pega qual a sessão default da música
		
	AudioPlayer.set("parameters/switch_to_clip",current_section) # seta a sessão pra ela
	AudioPlayer.set_stream(song_data.get_main_clips())           # seta a stream pro _current_song_node
	
	
	if AudioPlayer.get_stream().get_transition_list().size() == 0:   ## Se a table não for usada, usar configurações default
		_transition_type = song_data.get_track_transition()          # pega qual transição é usada entre os clips da musica
		var fade_mode  : int   = song_data.get_fade_mode()           # pega qual o fade_mod
		var fade_beats : float = song_data.get_fade_beats()          # pega em quanto faz o fade	
		# se a transição geral for feita por barras, seta como imediato pra poder usar o metodo custom
		if _transition_type == 2:
			AudioPlayer.get_stream().add_transition(-1,-1,0,0,fade_mode,fade_beats)
		# caso não seja, apenas usa a forma padrão
		else:
			AudioPlayer.get_stream().add_transition(-1,-1,_transition_type,0,fade_mode,fade_beats)
			
	else: # WARNING Tem forma melhor de fazer isso?
		for corrected in song_data.correct_clips_transition(): 
			## Para cada transição que precisa ser corrigida
			## Apaga a atual, e substitui por uma nova
			AudioPlayer.get_stream().erase_transition(corrected["from_to"][0],corrected["from_to"][1])
			if corrected["filler_clip"] == -1: # se não usar filler clips, adiciona sem
				AudioPlayer.get_stream().add_transition(
					corrected["from_to"][0],corrected["from_to"][1],
					0,corrected["to_time"],corrected["fade_mode"],
					corrected["fade_beats"],false,-1,corrected["hold_previous"]
				)
			else: # se usar filler clips, passa eles
				AudioPlayer.get_stream().add_transition(
					corrected["from_to"][0],corrected["from_to"][1],
					0,corrected["to_time"],corrected["fade_mode"],
					corrected["fade_beats"],true,corrected["filler_clip"],
					corrected["hold_previous"]
				)
			_corrected_transitions.append(corrected["from_to"]) # dá append na variavel de transições corrigidas pra check depois
		Logger.info("corrected these transitions: "+str(_corrected_transitions))
