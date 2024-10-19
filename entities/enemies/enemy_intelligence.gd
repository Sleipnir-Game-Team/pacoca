extends Node

var rng = RandomNumberGenerator.new()
@export var min_attack_player_chance = 25
@export var min_trow_chance = 40
@export var min_trow_to_enemie_chance = 35

var player = preload("res://entities/player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func decision():
	var enemie_decision_number := rng.randi_range(0, 99)
	
	if enemie_decision_number < min_attack_player_chance:
		attack_player()
	elif enemie_decision_number < min_trow_chance + min_attack_player_chance:
		attack_player()
	elif enemie_decision_number < min_trow_to_enemie_chance + min_trow_chance + min_attack_player_chance:
		trow_ball_to_ally()

func attack_player():
	var player_position = player.get_global_position()
	
func trow_ball_away():
	pass
	
func trow_ball_to_ally():
	pass
	
