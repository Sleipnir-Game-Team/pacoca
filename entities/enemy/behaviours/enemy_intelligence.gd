extends Node


var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@export var attack_player_chance: int = 40
@export var throw_away_chance: int = 60


@onready var kick: Kick = %Kick
@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var ball: Ball = get_tree().get_first_node_in_group("Ball")

## Quando a bola está em range de uma ação essa função é executada
func decision() -> void:
	if ball.heat.is_burning: # Comportamento quando a bola está pegando fogo - no momento o inimigo fica incapaz de reagir
		return
	
	var decision_number: int = rng.randi_range(0, 99)
	
	if decision_number < attack_player_chance:
		attack_player()
	elif decision_number < throw_away_chance + attack_player_chance:
		throw_ball_away()

func attack_player() -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("Player")
		
	var enemy_position: Vector2 = get_parent().global_position
	kick.start(enemy_position.direction_to(player.global_position))

func throw_ball_away() -> void:
	# TODO
	attack_player()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if !get_parent().is_stopped:
		if area.name == "ContactArea":
			decision()
