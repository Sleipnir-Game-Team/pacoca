extends Node


var rng = RandomNumberGenerator.new()
@export var min_attack_player_chance = 25
@export var min_trow_chance = 40
@export var min_trow_to_enemie_chance = 35
@export var ball: Ball
@export_group('Kick', 'kick')

var player: Player

#var player = preload("res://entities/player/player.tscn")

@onready var kick = %Kick


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#quando está perto o suficiente ele faz a decisão




func decision():
	var enemie_decision_number := rng.randi_range(0, 99)
	
	if enemie_decision_number < min_attack_player_chance:
		attack_player()
	elif enemie_decision_number < min_trow_chance + min_attack_player_chance:
		attack_player()
	elif enemie_decision_number < min_trow_to_enemie_chance + min_trow_chance + min_attack_player_chance:
		trow_ball_to_ally()

func attack_player():
	var player_position = player.global_position
	var inimigo_position = get_parent().global_position
	
	
	kick.trigger(inimigo_position.direction_to(player_position))
	print("chute dado")
	
	

func trow_ball_away():
	pass
	
func trow_ball_to_ally():
	pass
	





func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Área entrou:", area.name)
	if area.name == "ContactArea":
		print("encotrou algo")
		decision()

func _on_kick_hit(direction: Vector2, data: Dictionary) -> void:
	ball = data.collider as Ball
	ball.change_angle(rad_to_deg(direction.angle()))
