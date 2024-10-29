extends Control

@onready var wave_label = $CanvasLayer/HBoxContainer/left_container/info_container/score_card/VBoxContainer/score
@onready var health_bar = $CanvasLayer/HBoxContainer/left_container/info_container/life_card/MarginContainer/VBoxContainer2/MarginContainer/HBoxContainer/VBoxContainer/health_bar

func _ready():
	get_tree().get_first_node_in_group("Player").change_life_bar.connect(change_life_bar)
	UI_Controller.wave_counter.connect(change_wave_counter)
	
func change_life_bar(life_point):
	health_bar.value += life_point

func change_wave_counter(wave):
	var current_wave = int(wave_label.text) + wave
	if current_wave == 5:
		wave_label.text = "BOSS"
	else:
		wave_label.text = str(current_wave)
