extends Node

@export_group('Limits', 'limit_')
@export var limit_left := -INF
@export var limit_right := INF
@export var limit_up := -INF
@export var limit_down := INF

@export var tp_amount := 0


func _process(_delta: float) -> void:
	if get_parent().position.x < limit_left:
		get_parent().position.x = limit_left + tp_amount
	if get_parent().position.x > limit_right:
		get_parent().position.x = limit_right - tp_amount
	if get_parent().position.y < limit_up:
		get_parent().position.y = limit_up + tp_amount
	if get_parent().position.y > limit_down:
		get_parent().position.y = limit_down - tp_amount
