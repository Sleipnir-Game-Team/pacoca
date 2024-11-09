extends Node

@export var group_name: String

func _enter_tree():
	# Expurga o gêmeo e se poe no grupo
	for node in get_tree().get_nodes_in_group(group_name):
		node.remove_from_group(group_name)
	get_parent().add_to_group(group_name)
