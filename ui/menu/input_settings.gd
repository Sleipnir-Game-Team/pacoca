extends MarginContainer

@onready var keybinding_list = get_node("%keybinding_list")
@onready var input_button_scene = preload("res://ui/buttons/input_button.tscn")
var is_remapping = false
var action_to_remap = null
var remapping_button = null

func _ready():
	verify_input_mapping()

func verify_input_mapping():
	var keybinding_settings = Config_Handler.load_all_keybinding_settings()
	var action_formatted_dict = format_actions(InputMap.get_actions(), keybinding_settings)
	var equal = true
	var count = 0
	while (equal && count < action_formatted_dict.keys().size()):
		var new_action = action_formatted_dict.keys()[count]
		if typeof(InputMap.action_get_events(new_action)[0]) != typeof(keybinding_settings[new_action]):
			equal = false
		count += 1
	count = 0
	if !equal:
		create_action_list(action_formatted_dict)
	else:
		update_action_list(action_formatted_dict, keybinding_settings)

func update_action_list(action_formatted_dict, keybinding_settings):
	for item in keybinding_list.get_children():
		item.queue_free()
		
	for action in action_formatted_dict:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("action_label")
		var input_label = button.find_child("input_label")
		action_label.text = action_formatted_dict[action]
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybinding_settings[action])
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			Config_Handler.save_keybinding_settings(action, events[0])
		else:
			input_label.text = ""
		
		keybinding_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func create_action_list(action_formatted_dict):
	InputMap.load_from_project_settings()
	for item in keybinding_list.get_children():
		item.queue_free()
		
	for action in action_formatted_dict:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("action_label")
		var input_label = button.find_child("input_label")
		action_label.text = action_formatted_dict[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
			Config_Handler.save_keybinding_settings(action, events[0])
		else:
			input_label.text = ""
		
		keybinding_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func format_actions(actions, keybinding_settings):
	var action_dict = {}
	for item in actions:
		if item in keybinding_settings.keys():
			match item:
				"player_up":
					action_dict[item] = "Cima"
				"player_down":
					action_dict[item] = "Baixo"
				"player_left":
					action_dict[item] = "Esquerda"
				"player_right":
					action_dict[item] = "Direita"
				"player_hit":
					action_dict[item] = "Rebater"
				"player_special":
					action_dict[item] = "Segurar"
	return action_dict


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("input_label").text = "Escolha a tecla..."


func _input(event):
	if is_remapping:
		if (event is InputEventKey) || (event is InputEventMouseButton && event.pressed):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_input_button(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()


func _update_input_button(button, event):
	button.find_child("input_label").text = event.as_text().trim_suffix(" (Physical)")
	Config_Handler.save_keybinding_settings(action_to_remap, event)


func _on_reset_button_pressed():
	var keybinding_settings = Config_Handler.load_all_keybinding_settings()
	var action_formatted_dict = format_actions(InputMap.get_actions(), keybinding_settings)
	create_action_list(action_formatted_dict)
