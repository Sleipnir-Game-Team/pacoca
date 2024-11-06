extends Node

## Par de Nome e NodePath dos AnimationPlayers
var players: Dictionary

func register(new_players: Dictionary) -> void:
	players = new_players

func play_animation(player, animation_name) -> void:
	get_node(players[player]).play(animation_name)

func stop_named_animation(player, animation_name) -> void:
	if(get_node(players[player]).current_animation == animation_name):
		get_node(players[player]).stop()
	
func stop_animation(player) -> void:
	get_node(players[player]).stop()
