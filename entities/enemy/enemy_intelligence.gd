extends Node

var player: Player

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var attack_player_chance: int = 25
@export var throw_away_chance: int = 40
@export var throw_towards_ally: int = 35

@export var ball: Ball

@export_group('Kick', 'kick')
@onready var kick: Kick = %Kick

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


## Quando está perto o suficiente ele faz a decisão
func decision() -> void:
	var decision_number := rng.randi_range(0, 99)
	
	if decision_number < attack_player_chance:
		attack_player()
	elif decision_number < throw_away_chance + attack_player_chance:
		attack_player()
	elif decision_number < throw_towards_ally + throw_away_chance + attack_player_chance:
		throw_ball_to_ally()

func attack_player() -> void:
	var enemy_position: Vector2 = get_parent().global_position
	kick.trigger(enemy_position.direction_to(player.global_position))

func throw_ball_away() -> void:
	pass

func throw_ball_to_ally() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "ContactArea":
		decision()

func _on_kick_hit(direction: Vector2, data: Dictionary) -> void:
	ball = data.collider as Ball
	ball.change_angle(rad_to_deg(direction.angle()))
