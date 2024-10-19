extends Node

## Quantas camadas de pause tem
##  0 - O jogo não está pausado
## +1 - O jogo está pausado por essa quantidade de fontes
var _pause_layers: int = 0:
	get:
		return _pause_layers
	set(value):
		_pause_layers = max(0, value)
		get_tree().paused = _pause_layers > 0

## Adiciona uma camada de pause
func pause() -> void:
	_pause_layers += 1
	Logger.info("Camada de pause adicionada, atualmente existem %s camadas" % [_pause_layers])

## Remove uma camada de pause
## ATENÇÃO: Utilizar essa função NÃO implica que o jogo será despausado
## Despausar o jogo exige que TODAS as camadas de pause sejam removidas
func resume() -> void:
	_pause_layers -= 1
	Logger.info("Camada de pause removida, atualmente existem %s camadas" % [_pause_layers])


func game_over() -> void:
	# TODO ISSO AQUI TÁ MEIO BOSTA, ACHO QUE ERA MELHOR SEMPRE EXISTIR UM MAIN E GAME_OVER SER PARTE INTERNA DELE
	# DO QUE A GENTE REMOVER E RECRIAR A MAIN QUANDO A PESSOA REJOGASSE
	var main: Control = get_node_or_null('../Main')
	
	get_tree().root.remove_child(main)
	main.queue_free()
	
	var ending_scene: PackedScene = load("res://ui/game_over.tscn")
	
	get_tree().root.add_child(ending_scene.instantiate())
