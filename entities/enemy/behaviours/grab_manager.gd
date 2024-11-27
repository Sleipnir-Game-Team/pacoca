class_name Grab_manager
extends Node

var rng_x := RandomNumberGenerator.new()
var rng_y := RandomNumberGenerator.new()

var target : Vector2

@onready var grab: Grab = $"../Grab"

@export var time_to_throw: float = 1.5



func grab_ball(ball: Node2D) -> void:
	Logger.info("Iniciando o grab em: " + str(ball.name))
	grab.start(Vector2(0, 0))  # Pode ajustar a direção inicial conforme necessário
	
	
	# Define direção aleatória para arremesso
	var x := rng_x.randf_range(-1, 1)
	var y := rng_y.randf_range(0.9, 1)
	target = Vector2(x, y).normalized()
	Logger.info("esse é o alvo: " + str(target))
	
	await get_tree().create_timer(time_to_throw).timeout
	
	if not grab.is_holding():
		Logger.info("Nada para arremessar!")
		return
	Logger.info("Tempo de grab acabou, arremessando na direção: " + str(target))
	grab.start(target)
	


func _on_hurt_box_body_entered(body: Node2D) -> void:
	if !get_parent().is_stopped:
		if body is Ball:  
			Logger.info("Bola detectada: " + str(body.name))
			grab_ball(body)  # Chama a função para pegar a bola
		else:
			Logger.warn("Corpo detectado não é uma bola: " + str(body.name))
