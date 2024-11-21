class_name Kick
extends AreaTrigger
## Um [b]Kick[/b] extende o [AreaTrigger] e adiciona a lógica necessária para chutar a bola na direção desejada.
##
## Toda a implementação ocorre sobreescrevendo o método _handler.
## - [method Ball._on_kick] é chamado para direcionar a bola com base na direção do chute.
## - [signal Kick.kicked] é emitido com a informação de direção

var attack_direction: Vector2

signal kicked(direction: float)

func _handler(direction: Vector2, data: Dictionary) -> void:
	var ball: Ball = data.collider
	ball._on_kick(rad_to_deg(direction.angle()))
	kicked.emit(rad_to_deg(direction.angle()))
