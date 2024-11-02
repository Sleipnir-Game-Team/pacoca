extends Node2D

@export_group('Limits', 'limit_')
## Até onde o mouse é capturado à esquerda
@export var limit_left = -INF
## Até onde o mouse é capturado à direita
@export var limit_right = INF
## Até onde o mouse é capturado pra cima
@export var limit_up = -INF
## Até onde o mouse é capturado pra baixo
@export var limit_down = INF

## Quando o mouse não for capturado ele deve retornar ao estado padrao?
@export var reset_off_limits := false

@export var default_aim_direction := Vector2.ZERO
var last_aim_direction = default_aim_direction

signal rotate(direction)

func _physics_process(_delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if (mouse_position.x < limit_left or mouse_position.x > limit_right or mouse_position.y > limit_down or mouse_position.y < limit_up):
		if reset_off_limits:
			rotate.emit(default_aim_direction)
		else:
			rotate.emit(last_aim_direction)
	else:
		var aim_direction: Vector2 = global_position.direction_to(mouse_position)
		last_aim_direction = aim_direction
		rotate.emit(aim_direction)
