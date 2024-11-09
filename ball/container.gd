extends Node

@export_group('Limits', 'limit_')
@export var limit_left = -INF
@export var limit_right = INF
@export var limit_up = -INF
@export var limit_down = INF


func _process(delta):
	if get_parent().position.x < limit_left:
		get_parent().position.x = limit_left
	if get_parent().position.x > limit_right:
		get_parent().position.x = limit_right
	if get_parent().position.y < limit_up:
		get_parent().position.y = limit_up
	if get_parent().position.y > limit_down:
		get_parent().position.y = limit_down
